require 'bunny'
require 'json'

conn = Bunny.new
conn.start

ch    = conn.create_channel
req_x = ch.direct('datastore.export_requests')
req_q = ch.queue('datastore.export_requests')

req_q.bind(req_x).subscribe do |delivery_info, metadata, data|
  STDERR.puts 'Handling export request'
  request = JSON.parse(data)
  res_x = ch.direct(request['exchange'], :auto_delete => true)
  (1..20).each do |i|
    STDERR.puts 'Published message'
    res_x.publish(JSON.generate({
      :response => 'ok',
      :status   => 'ok', 
      :pkey     =>  i.to_s, 
      :metadata => %{
        <?xml version="1.0" ?>
        <mods xmlns="mods">
          <title>Document Title</title>
        </mods>
      }
    })
  end
  res_x.publish('EOR')
end

STDERR.puts 'Datastore ready for export requests.'

terminated = false

Signal.trap(:INT) do
  STDERR.puts "\nShutting down..."
  terminated = true
end

sleep 1 until terminated

conn.close

STDERR.puts 'Stopped.'
