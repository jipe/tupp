require 'bunny'
require 'json'
require 'datastore'
require 'harvester'

class Harvester
  class DS2Harvester < Harvester
    attr_accessor :datastore

    def initialize(request, options = {})
      super
      @datastore = Datastore.new(ENV['DS2_RABBITMQ_URL'])
    end

    def harvest
      STDERR.puts 'Harvesting from DS2'
      ds2_request = create_ds2_request(request)
      STDERR.puts "DS2 request is '#{JSON.generate(ds2_request)}'"
      datastore.export_events(ds2_request) do |message|
        STDERR.puts "Received event '#{message}'"
      end
    end

    private

    def split_request(request)
    end

    def create_ds2_request(request)
      {
        'fromdate'  => 'from',
        'untildate' => 'until',
        'set'       => 'set',
        'pkey'      => 'id'
      }.map {|k,v| [k, request[v]]}
       .to_h
       .reject {|k,v| v.nil?}
    end
  end
end
