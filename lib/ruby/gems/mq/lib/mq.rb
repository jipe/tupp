require 'bunny'

class MQ
  def initialize(opts = {})
    opts[:connection_url] ||= ENV['RABBITMQ_URL']
    @conn = Bunny.new(opts[:connection_url])
    @conn.start
    @ch = @conn.create_channel
    @ch.prefetch(opts[:prefetch]) if opts[:prefetch]

    @xs = {}
    @qs = {}
  end

  def close
    @conn.close unless @conn.nil?
  end

end
