class HarvestRequest
  attr_accessor :id, :set, :from_time, :until_time

  def initialize(args)
    id         = args[:id]
    set        = args[:set]
    from_time  = args[:from]
    until_time = args[:until]
  end
end
