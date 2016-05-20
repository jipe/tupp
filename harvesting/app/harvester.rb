class Harvester
  
  attr_accessor :request, :batch_size

  def initialize(request, options = {})
    @request    = request.dup
    @batch_size = options[:batch_size] || 10_000
  end

  def harvest
  end

  def complete?
    true
  end

  def continued_harvest_request
    nil
  end

end
