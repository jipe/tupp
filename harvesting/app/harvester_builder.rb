require 'harvester'
require 'harvester/all'

class HarvesterBuilder
  def self.new_harvester(request)
    self.harvesters[request['provider']].new(request) 
  end

  private

  def self.harvesters
    {
      'ds2' => Harvester::DS2Harvester
    }
  end
end
