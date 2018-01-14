require 'harvester'
require 'harvester/all'

class HarvesterBuilder
  def self.new_harvester(request)
    STDERR.puts "No builder for provider '#{request.provider}'" unless self.harvesters[request.provider]
    self.harvesters[request.provider].new(request)
  end

  def self.harvesters
    {
      'ds2' => Harvester::DatastoreHarvester
    }
  end
end
