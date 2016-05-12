require 'bunny'

interrupted = false

Signal.trap(:INT) do
  interrupted = true
end

STDERR.puts "Management interface is online."

sleep 1 until interrupted

STDERR.puts "Shutting down."
