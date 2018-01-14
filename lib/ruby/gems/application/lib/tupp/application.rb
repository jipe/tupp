require 'bunny'
require 'thread'
require 'uri'
require 'mq'
require 'tupp'

module TUPP
  module Application
    def self.with_mq(mq = MQ.new)
      raise 'No block given' unless block_given?

      mutex       = Mutex.new
      interrupted = false
      interrupter = ->() { interrupted = true }

      init_mq(mq)

      %w(INT TERM).each do |sig| 
        Signal.trap(sig) do 
          STDERR.puts "\nReceived #{sig} signal. Shutting down."
          interrupter.()
        end
      end

      yield mq, mutex, interrupter

      sleep 1 until interrupted

      mutex.synchronize do
        mq.close
      end
    end

    private

    def self.init_mq(mq)
      ch = mq.pub_conn.create_channel

      ch.topic('repository_events', durable: true) unless mq.pub_conn.exchange_exists?('repository_events')

      ch.close
    end
  end
end
