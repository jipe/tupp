require 'core_ext/time'
require 'bunny'
require 'json'

class Datastore
  def initialize(rabbitmq_url = ENV['RABBITMQ_URL'])
    @rabbitmq_url = rabbitmq_url
  end

  def export_events(request)
    raise unless block_given?

    conn = Bunny.new(@rabbitmq_url)
    conn.start

    ch = conn.create_channel
    
    req_x = ch.topic('dticds2topic', durable: true)
    res_x = ch.direct("export?#{create_exchange_name(request)}", auto_delete: true)
    res_q = ch.queue(res_x.name, auto_delete: true, exclusive: true)
    
    export_request = create_export_request(request, res_x.name)
    req_x.publish(JSON.generate(export_request), routing_key: 'export')

    res_q.bind(res_x).subscribe(block: true) do |delivery_info, metadata, data|
      case data
      when /"response":"eor"/
        conn.close
      else
        yield data
      end
    end
  ensure
    conn.close unless conn.nil?
  end

  private

  def create_export_request(request, exchange_name)
    {
      'routingkey' => exchange_name,
      'requestor'  => 'tupp',
      'fromdate'   => request.from,
      'untildate'  => request.until,
      'set'        => request.set,
      'pkey'       => request.id
    }
      .reject {|k,v| v.nil?}
  end

  def create_exchange_name(request)
    create_export_request(request, nil)
      .map    {|k,v| "#{k}=#{v}"}
      .join('&')
  end
end
