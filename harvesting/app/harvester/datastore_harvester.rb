require 'bunny'
require 'json'
require 'datastore'
require 'harvester'
require 'core_ext/time'

class Harvester
  class DatastoreHarvester < Harvester
    attr_reader :datastore

    MAX_HARVEST_INTERVAL_IN_SECONDS = 60*60*24 # 1 day

    def initialize(request, options = {})
      super
      @datastore = Datastore.new(ENV['DS_RABBITMQ_URL'])
      @provider  = 'ds2'
    end

    def harvest(&block)
      datastore.export_events(request) do |message|
        block.call(message)
      end
    end

    def split_request(request)
      request.from  = Time.new(2010) unless request.from # Pre-DS timestamp
      request.until = Time.now       unless request.until

      t1 = request.from
      t2 = request.until

      if t2 - t1 > MAX_HARVEST_INTERVAL_IN_SECONDS
        next_request  = request.dup
        request.until = next_request.from = t1 + MAX_HARVEST_INTERVAL_IN_SECONDS
        [request, next_request]
      else
        [request, nil]
      end
    end
  end
end
