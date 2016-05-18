require 'bunny'
require 'json'
require 'harvester_builder'
require 'exceptions'
require 'thread'

conn  = Bunny.new
mutex = Mutex.new
conn.start

ch = conn.create_channel
ch.prefetch(1)

err_x = ch.direct('errors',   :durable => true)
req_x = ch.direct('requests', :durable => true)

req_q = ch.queue(req_x.name, :durable => true)

interrupted = false

req_q.bind(req_x, :routing_key => 'harvest').subscribe(:manual_ack => true) do |delivery_info, metadata, data|
  mutex.synchronize do
    case data
    when 'INT'
      STDERR.puts 'Received INT signal via MQ.'
      interrupted = true
    else
      begin
        harvester = HarvesterBuilder.new_harvester(JSON.parse(data))
        STDERR.puts "Harvester is #{harvester}"
        harvester.harvest
        unless harvester.complete?
          next_request = harvester.continued_harvest_request
          STDERR.puts "Enqueueing next request: '#{JSON.generate next_request}'"
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

Signal.trap(:INT) do
  interrupted = true
end

STDERR.puts 'Ready to process harvest requests.'

sleep 1 until interrupted

STDERR.puts 'Shutting down.'

mutex.synchronize { conn.close unless conn.nil? }

