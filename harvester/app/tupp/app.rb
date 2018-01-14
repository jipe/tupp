require 'tupp/application'
require 'tupp/record_store'
require 'tupp/xml'
require 'tupp/xml/mods'

record_store = TUPP::RecordStore.new

TUPP::Application.with_mq do |mq, mutex, interrupter|
  mq.subscribe(exchange: 'repository_events', queue: 'update_record_store', routing_keys: ['update.#', 'delete.#'], parse_json: true) do |message|
    mutex.synchronize do
      case message.routing_key
      when /^delete/
        record_store.delete(id:        message.body['pkey'],
                            timestamp: message.body['timestamp'])
      when /^update/
        record_store.update(id:        message.body['pkey'],
                            timestamp: message.body['timestamp'],
                            record:    TUPP::XML.digest(message.body['metadata'], TUPP::XML::MODS::DocumentHandler.new))
      end
    end
  end
  STDERR.puts 'Ready to process repository events'
end
