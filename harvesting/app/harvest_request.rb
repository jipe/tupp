require 'core_ext/time'
require 'json'
require 'securerandom'

class HarvestRequest
  attr_accessor :harvest_id, :provider, :id, :set, :from, :until

  def initialize(args = {})
    @provider   = args[:provider]
    @id         = args[:id]
    @set        = args[:set]
    @from       = args[:from]
    @until      = args[:until]
    @harvest_id = SecureRandom.uuid
  end

  def self.parse(data)
    json_request     = JSON.parse(data)
    request          = HarvestRequest.new
    request.provider = json_request['provider']
    request.id       = json_request['id']
    request.set      = json_request['set']
    request.from     = Time.parse(json_request['from'])  if json_request['from']
    request.until    = Time.parse(json_request['until']) if json_request['until']
    request
  end

  def to_h
    [
      :provider, 
      :id, 
      :set, 
      :from, 
      :until
    ]
      .reject {|k| self.send(k).nil?}
      .map    {|k| [k, self.send(k)]}
      .to_h
  end

  def to_s
    JSON.generate(self.to_h)
  end
end
