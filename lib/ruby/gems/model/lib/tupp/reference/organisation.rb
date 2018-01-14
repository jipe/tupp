require 'tupp/reference'

module TUPP
  class Reference::Organisation < Reference
    attr_accessor :name, :suborganisations

    def initialize(args = {})
      @name             = args[:name]
      @suborganisations = args[:suborganisations] || []
    end
  end
end
