require 'tupp/reference/event'

module TUPP
  class Conference < Event
    def initialize(document = {})
      super(document)
    end
  end
end
