require 'tupp/reference'

module TUPP
  class Organisation < Reference
    attr_accessor :name, :suborganisations

    def initialize(document = {})
      super(document)
    end
  end
end
