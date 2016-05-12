require 'bunny'
require 'json'
require 'harvester'
require 'exceptions'

conn = Bunny.new
conn.start

ch = conn.create_channel
ch.prefetch(1)

err_x = ch.direct('errors',   :durable => true)
req_x = ch.direct('requests', :durable => true)

req_q = ch.queue(req_x.name, :durable => true)

interrupted = false
busy        = false

req_q.bind(req_x, :routing_key => 'harvest').subscribe(:manual_ack => true) do |delivery_info, metadata, data|
  busy = true
  busy = false and return if interrupted

  case data
  when 'INT'
    STDERR.puts 'Received INT signal via MQ.'
    interrupted = true
  else
    harvest(data)
  end

  ch.ack(delivery_info.delivery_tag)
  busy = false
end

Signal.trap(:INT) do
  interrupted = true
end

sleep 1 until interrupted

STDERR.puts 'Waiting for worker to finish.'

sleep 1 while busy

STDERR.puts 'Shutting down.'

conn.close

def harvest(data)
  begin
    harvester = find_harvester(JSON.parse(data))
    harvester.harvest
    unless harvester.completed?
      next_request = harvester.continued_harvest_request
      req_x.publish(JSON.generate(next_request), :routing_key => 'harvest', :persistent => true)
    end
  rescue JSON::ParserError
    err_x.publish("Unparseable request: #{data}", :routing_key => 'harvest', :persistent => true)
  rescue UnknownProviderError => e
    err_x.publish(e.message, :routing_key => 'harvest', :persistent => true)
  else
    err_x.publish("Unknown error in request: #{data}", :routing_key => 'harvest', :persistent => true)
  end      
end

def enabled_providers(provider_string = ENV['PROVIDERS'] || '')
  provider_string.split(/\s*,\s*/)
end

def find_harvester(request)
  case request['provider']
  when 'ds2'
    Harvester::Ds2Harvester.new(request)
  else
    raise UnknownProviderError.new(request['provider'])
  end
end
