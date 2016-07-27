require 'time'

class Time
  def to_s
    self.iso8601
  end
end
