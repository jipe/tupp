require 'bunny'
require 'json'

conn = Bunny.new
conn.start

ch    = conn.create_channel
req_x = ch.topic('dticds2topic', :durable => true)
req_q = ch.queue('export', :durable => true)

req_q.bind(req_x, :routing_key => 'export').subscribe do |delivery_info, metadata, data|
  STDERR.puts 'Handling export request'
  request = JSON.parse(data)
  res_x   = ch.direct(request['exchange'], :auto_delete => true)

  (1..10).each do |i|
    result = {
      :request  => 'ok',
      :status   => 'ok',
      :pkey     => i,
      :metadata => %{
        <?xml version="1.0" encoding="utf-8"?>
        <mods xmlns="">
          <identifier type="ds.dtic.dk:id:recordid">#{i}</identifier>
          <identifier type="ds.dtic.dk:id:dedupkey">#{(i-1) / 3}</identifier>
        </mods>
      }.strip
    }

    res_x.publish(JSON.generate(result))
  end
  res_x.publish(JSON.generate(:request => 'eor'))
end

Signal.trap(:INT) do
  STDERR.puts "\nShutting down"
  Thread.current.exit
end

STDERR.puts 'DS2 ready for requests.'

at_exit { conn.close unless conn.nil? }

sleep
