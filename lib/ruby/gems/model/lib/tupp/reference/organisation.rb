require 'tupp/reference'

module TUPP
  class Reference::Organisation < Reference
    attr_accessor :name, :suborganisations

    def initialize(document = {})
      super(document)
    end
  end
end
