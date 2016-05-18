require 'bunny'
require 'json'
require 'harvester'
require 'exceptions'
require 'thread'

STDERR.puts "RABBITMQ_URL = #{ENV['RABBITMQ_URL']}"
conn  = Bunny.new
mutex = Mutex.new
conn.start

ch = conn.create_channel
ch.prefetch(1)

err_x = ch.direct('errors',   :durable => true)
req_x = ch.direct('requests', :durable => true)

req_q = ch.queue(req_x.name, :durable => true)

req_q.bind(req_x, :routing_key => 'harvest').subscribe(:manual_ack => true) do |delivery_info, metadata, data|
  mutex.synchronize do
    case data
    when 'INT'
      STDERR.puts 'Received INT signal via MQ.'
      interrupted = true
    else
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

    ch.ack(delivery_info.delivery_tag)
  end
end

interrupted = false

Signal.trap(:INT) do
  STDERR.puts 'Shutting down'
  interrupted = true
end

sleep 1 until interrupted

mutex.synchronize { conn.close unless conn.nil? }

def enabled_providers(provider_string = ENV['PROVIDERS'] || '')
  provider_string.split(/\s*,\s*/)
end

def find_harvester(request)
  provider = request['provider']
  raise UnknownProviderError.new(provider) unless harvesters[provider] && enabled_providers.include?(provider)
  harvesters[provider].new(request)
end

def harvesters
  {
    'ds2' => Harvester::Ds2Harvester
  }
end
