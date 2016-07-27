require 'application'
require 'json'

Application.with_mq do |interrupter, ch, mutex|
  req_x = ch.topic('dticds2topic', :durable => true)
  req_q = ch.queue('export', :durable => true)

  req_q.bind(req_x, :routing_key => 'export').subscribe do |delivery_info, metadata, data|
    mutex.synchronize do
      request = JSON.parse(data)
      res_x   = ch.direct(request['routingkey'], :auto_delete => true)

      (1..10).each do |i|
        result = {
          :response => 'ok',
          :status   => 'ok',
          :pkey     => i,
          :metadata => %{
            <?xml version="1.0" encoding="utf-8"?>
            <mods xmlns="http://www.loc.gov/mods/v3">
              <titleInfo><title>Record title</title></titleInfo>
              <identifier type="ds.dtic.dk:id:recordid">#{i}</identifier>
              <identifier type="ds.dtic.dk:id:dedupkey">#{(i-1) / 3}</identifier>
            </mods>
          }.strip
        }
        res_x.publish(JSON.generate(result))
      end
      res_x.publish(JSON.generate(:response => 'eor'))
    end
  end

  STDERR.puts 'Ready to process export requests.'
end
