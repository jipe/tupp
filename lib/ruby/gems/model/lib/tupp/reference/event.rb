require 'tupp/reference'

module TUPP
  class Event < Reference
    attr_accessor :locations,
                  :from_date,
                  :until_date,
                  :coordinators

    def initialize(document = {})
      super(document)
    end
  end
end
