require 'json'
require 'harvester_builder'
require 'harvest_request'
require 'harvest_result'
require 'exceptions'
require 'application'
require 'core_ext/time'

Application.with_mq do |interrupter, ch, mutex|
  ch.prefetch(1)

  err_x = ch.direct('errors',   durable: true)
  req_x = ch.direct('requests', durable: true)

  req_q = ch.queue(req_x.name, durable: true)

  req_q.bind(req_x, routing_key: 'harvest').subscribe(manual_ack: true) do |delivery_info, metadata, data|
    mutex.synchronize do
      case data
      when 'INT'
        interrupter.()
      else
        begin
          STDERR.puts "Handling request: '#{data}'"
          harvester = HarvesterBuilder.new_harvester(HarvestRequest.parse(data))
          harvester.harvest do |data|
            received_at = Time.now
            ['store.original', 'extract'].each do |routing_key|
              req_x.publish(HarvestResult.new(provider: harvester.provider, received_at: received_at, data: data).to_s, routing_key: routing_key, persistent: true)
            end
          end
          unless harvester.complete?
            req_x.publish(harvester.next_request.to_s, routing_key: 'harvest', persistent: true)
          end
        rescue JSON::ParserError
          STDERR.puts "Unparseable request: #{data}"
          err_x.publish("Unparseable request: #{data}", routing_key:  'harvest', persistent: true)
        rescue UnknownProviderError => e
          STDERR.puts "Unknown provider error: #{e.message}"
          err_x.publish(e.message, routing_key: 'harvest', persistent: true)
        rescue => e
          STDERR.puts "Unknown error in request: '#{data}' #{e.message}"
          err_x.publish("Unknown error in request: #{data}", routing_key: 'harvest', persistent: true)
        end      
      end
      ch.ack(delivery_info.delivery_tag)
    end
  end
  STDERR.puts 'Ready to process harvest requests.'
end
