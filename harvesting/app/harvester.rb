require 'securerandom'

class Harvester
  attr_reader :request, :next_request, :provider

  def initialize(request)
    (@request, @next_request) = split_request(request.dup)
  end

  def harvest(&block)
  end

  def split_request(request)
    [request, nil]
  end

  def complete?
    next_request.nil?
  end
end
