require 'tupp'

module TUPP
  class Identifier
    attr_accessor :type, :value

    def initialize args
      @type  = args[:type]  if args[:type]
      @value = args[:value] if args[:value]
    end

    def ==(other)
      return false if other.nil?
      self.type == other.type && self.value == other.value
    end

    alias :eql? :==
  end
end
