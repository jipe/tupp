require 'bunny'
require 'pg'

interrupted = false

Signal.trap(:INT) do
  interrupted = true
end
  
#conn = Bunny.new
#conn.start

#ch = conn.create_channel

#req_x = ch.direct('datastore.export_requests')
STDERR.puts 'Enqueueing ready.'

sleep 1 until interrupted

STDERR.puts 'Shutting down.'

#conn.close
