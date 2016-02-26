require 'bunny'

class Datastore

  def initialize(rabbitmq_url = ENV['RABBITMQ_URL'])
    @rabbitmq_url = rabbitmq_url
  end

  def export_events(from_time, until_time, set)
    raise unless block_given?

    conn = Bunny.new(@rabbitmq_url)
    conn.start

    ch = conn.create_channel
    
    req_x = ch.direct('datastore.export_requests')
    res_x = ch.direct("datastore.export_results.tupp.#{Time.now}", :auto_delete => true)
    res_q = ch.queue(res_x, :auto_delete => true, :exclusive => true)
    
    export_complete = false

    res_q.bind(res_x).subscribe do |delivery_info, metadata, data|
      if data == 'EOR'
        export_complete = true
      else
        yield data
      end
    end

    req_x.publish(%{
      {
        "exchange"  : "#{res_x.name}",
        "fromdate"  : "#{from_time}",
        "untildate" : "#{until_time}",
        "set"       : "#{set}",
        "requestor" : "tupp"
      }
    })

    sleep 1 until export_complete
  ensure
    conn.close unless conn.nil?
  end
end
