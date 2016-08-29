require 'bunny'
require 'thread'

module Application

  def self.with_mq(rabbitmq_url = ENV['RABBITMQ_URL'])
    raise 'No block given' unless block_given?

    mutex = Mutex.new
    conn  = Bunny.new(rabbitmq_url)

    STDERR.puts 'Waiting for MQ availability.'

    loop do
      begin
        conn.start
        break
      rescue Bunny::TCPConnectionFailed
        sleep 1
      end
    end

    interrupted = false

    %w(INT TERM).each do |sig| 
      Signal.trap(sig) do 
        STDERR.puts "\nReceived #{sig} signal. Shutting down."
        interrupted = true
      end
    end

    interrupter = ->() { interrupted = true }

    yield interrupter, conn, mutex

    sleep 1 until interrupted

    mutex.synchronize { conn.close unless conn.nil? }
  end

end
