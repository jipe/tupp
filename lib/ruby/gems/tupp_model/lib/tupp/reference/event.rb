require 'tupp/reference'

module TUPP
  class Reference
    class Event
      attr_accessor :locations,
                    :from_date,
                    :until_date,
                    :coordinators
    end
  end
end
