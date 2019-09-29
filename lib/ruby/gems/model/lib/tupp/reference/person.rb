require 'tupp/reference'

module TUPP
  class Person < Reference
    attr_accessor :first_name, :last_name, :affiliations

    def initialize(document = {})
      super(document)
    end
  end
end
