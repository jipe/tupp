require 'datastore'

datastore = Datastore.new(ENV['DS2_RABBITMQ_URL'])

export_request = {
  :from  => '2016-04-28T00:00:00',
  :until => '2016-04-29T00:00:00',
  :set   => 'orbit'
}

put 'Sending export request'

datastore.export_events(export_request) do |message|
  puts message
end
