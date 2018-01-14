require 'tupp/reference'

module TUPP
  class Reference::Event < Reference
    attr_accessor :locations,
                  :from_date,
                  :until_date,
                  :coordinators
  end
end
