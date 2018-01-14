require 'tupp'

module TUPP
  class Identifier
    attr_reader :type, :value

    def initialize(type: nil, value: nil)
      @type  = args[:type]  if args[:type]
      @value = args[:value] if args[:value]
    end

    def ==(other)
      return false if other.nil?
      self.type == other.type && self.value == other.value
    end

    def hash
      (self.type.to_s + self.value.to_s).hash
    end

    alias :eql? :==
  end
end
