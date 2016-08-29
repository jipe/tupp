require 'core_ext/time'
require 'json'
require 'securerandom'

class HarvestRequest
  attr_accessor :id, :provider, :identifier, :set, :from, :until

  def initialize(args = {})
    @id         = args[:id] || SecureRandom.uuid
    @provider   = args[:provider]
    @identifier = args[:identifier]
    @set        = args[:set]
    @from       = args[:from]
    @until      = args[:until]
  end

  def self.parse(data)
    json_request       = JSON.parse(data)
    request            = HarvestRequest.new
    request.id         = json_request['id'] if json_request['id']
    request.provider   = json_request['provider']
    request.identifier = json_request['identifier']
    request.set        = json_request['set']
    request.from       = Time.parse(json_request['from'])  if json_request['from']
    request.until      = Time.parse(json_request['until']) if json_request['until']
    request
  end

  def to_h
    [
      :id,
      :provider,
      :identifier,
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
