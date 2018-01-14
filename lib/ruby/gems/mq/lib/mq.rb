require 'bunny'
require 'json'
require 'tupp'

module TUPP
  class MQ
    class Config
      attr_reader :url, :host, :port, :vhost, :user, :pass, :api_url, :api_user, :api_pass

      def initialize(
        url:      ENV['RABBITMQ_URL'] || 'amqp://guest:guest@localhost:5672/%2f',
        api_url:  ENV['RABBITMQ_API_URL'],
        api_user: ENV['RABBITMQ_API_USER'],
        api_pass: ENV['RABBITMQ_API_PASS']
      )   
        uri = URI.parse(url)

        @url   = url
        @host  = uri.host
        @port  = uri.port
        @vhost = uri.path
        @user  = uri.user
        @pass  = uri.password

        @vhost.sub!(/^\//, '') 

        @api_url  = api_url || "http://#{@host}:#{port + 10_000}/api"
        @api_user = api_user || @user
        @api_pass = api_pass || @pass
      end 
    end 

    class Message
      attr_reader :body, :priority, :routing_key

      def initialize(body:, priority:, routing_key:)
        @body        = body
        @priority    = priority
        @routing_key = routing_key
      end
    end

    class Subscription
      def initialize(ch, consumer)
        @ch       = ch
        @consumer = consumer
      end

      def cancel
        @consumer.cancel
        @ch.close
      end
    end

    attr_reader :pub_conn, :sub_conn

    def initialize(config: Config.new)
      @pub_conn = Bunny.new(config.url)
      @sub_conn = Bunny.new(config.url)

      [@pub_conn, @sub_conn].each do |conn|
        loop do
          begin
            conn.start
            break
          rescue Bunny::TCPConnectionFailed
            sleep 1
          end
        end
      end
    end 

    def subscribe(exchange: 'amq.direct', queue:, routing_keys:, prefetch: 1, parse_json: false)
      ch = @sub_conn.create_channel
      q  = ch.queue(queue, durable: true, arguments: {'x-max-priority': 5})
      ch.prefetch(prefetch)

      routing_keys.each { |routing_key| q.bind(exchange, routing_key: routing_key) }

      consumer = q.subscribe(manual_ack: true) do |delivery_info, metadata, message|
        begin
          message = JSON.parse(message) if parse_json
          yield Message.new(body: message, priority: metadata.priority, routing_key: metadata.routing_key)
          ch.ack
        rescue
          ch.nack
        end
      end

      Subscription.new(ch, consumer)
    end

    def send(exchange: 'amq.direct', routing_key:, message:, priority: 3)
      ch = @pub_conn.create_channel
      ch.basic_publish(message, exchange, routing_key, priority: priority)
      ch.close
    end

    def close
      [pub_con, sub_conn].each { |conn| conn.close unless conn.nil? }
    end
  end 
end
