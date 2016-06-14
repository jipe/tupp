class Harvester
  attr_reader :request, :batch_size, :next_request

  def initialize(request, options = {})
    @batch_size = options[:batch_size] || 10_000
    (@request, @next_request) = split_request(request.dup)
  end

  def harvest
  end

  def split_request(request)
    [request, nil]
  end

  def complete?
    next_request.nil?
  end

end
