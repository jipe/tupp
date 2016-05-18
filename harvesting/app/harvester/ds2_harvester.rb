require 'bunny'
require 'datastore'
require 'harvester'

class Harvester
  class DS2Harvester < Harvester

    def initialize(request)
      super
      @datastore = Datastore.new(ENV['DS2_RABBITMQ_URL'])
      @count = 0
    end

    def harvest
      STDERR.puts "Harvesting from DS2"
      @count += 1
    end

    def complete?
      @request['eor']
    end

    def continued_harvest_request
      {
        'provider' => 'ds2',
        'eor' => true
      }
    end

  end
end
