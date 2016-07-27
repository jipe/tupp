class HarvestResult
  attr_reader :provider, :received_at, :data

  def initialize(args = {})
    @provider    = args[:provider]
    @received_at = args[:received_at]
    @data        = args[:data]
  end

  def to_h
    [:provider, :received_at, :data].reject {|k| self.send(k).nil?}
                                    .map {|k| [k, self.send(k)]}
                                    .to_h
  end

  def to_s
    JSON.generate(self.to_h)
  end
end
