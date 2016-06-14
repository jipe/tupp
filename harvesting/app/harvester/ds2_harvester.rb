require 'bunny'
require 'json'
require 'datastore'
require 'harvester'
require 'time'

class Harvester
  class DS2Harvester < Harvester
    attr_reader :datastore

    MAX_HARVEST_INTERVAL_IN_SECONDS = 60*60*24

    def initialize(request, options = {})
      super
      @datastore = Datastore.new(ENV['DS2_RABBITMQ_URL'])
    end

    def harvest
      #STDERR.puts 'Harvesting from DS2'
      ds2_request = create_ds2_request(request)
      #STDERR.puts "DS2 request is '#{JSON.generate(ds2_request)}'"
      datastore.export_events(ds2_request) do |message|
        #STDERR.puts 'Received DS2 event'
      end
    end

    def split_request(request)
      #STDERR.puts 'Splitting request'
      request['from']  = '2010-01-01T01:00:00' unless request['from'] # Pre-DS2 timestamp
      request['until'] = Time.now.iso8601 unless request['until']

      t1 = Time.parse(request['from'])
      t2 = Time.parse(request['until'])
      if t2 - t1 > MAX_HARVEST_INTERVAL_IN_SECONDS
        next_request = request.dup
        request['until'] = next_request['from'] = (t1 + MAX_HARVEST_INTERVAL_IN_SECONDS).iso8601
        [request, next_request]
      else
        [request, nil]
      end
    end

    private

    def create_ds2_request(request)
      {
        'fromdate'  => 'from',
        'untildate' => 'until',
        'set'       => 'set',
        'pkey'      => 'id'
      }.map {|k,v| [k.to_sym, request[v]]}
       .to_h
       .reject {|k,v| v.nil?}
    end
  end
end
