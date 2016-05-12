require 'bunny'
require 'datastore'
require 'harvester'

class Harvester
  class Ds2Harvester < Harvester

    def initialize(request)
      @conn = Bunny.new
    end

  end
end
