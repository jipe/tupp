interrupted = false

Signal.trap(:INT) do
  interrupted = true
end
  
until interrupted do
  STDERR.puts 'Still here...'
  sleep 1
end
