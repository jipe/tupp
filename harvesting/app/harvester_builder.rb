require 'harvester'
require 'harvester/all'

class HarvesterBuilder
  def self.new_harvester(request)
    STDERR.puts "No builder for provider '#{request.provider}'" unless self.harvester_registry[request.provider]
    self.harvester_registry[request.provider].new(request)
  end

  def self.get_harvester(request)
    self.harvesters[request.provider] ||= self.new_harvester(request)
  end

  private

  def self.harvesters
    @harvesters ||= {}
  end

  def self.harvester_registry
    {
      'ds2' => Harvester::DatastoreHarvester
    }
  end
end
