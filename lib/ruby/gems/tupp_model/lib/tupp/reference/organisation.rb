require 'tupp'

module TUPP
  class Organisation
    attr_accessor :name, :suborganisations

    def initialize(args = {})
      @name             = args[:name]
      @suborganisations = args[:suborganisations] || []
    end
  end
end
