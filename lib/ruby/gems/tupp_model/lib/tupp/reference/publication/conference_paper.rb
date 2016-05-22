require 'tupp/reference/publication'
require 'tupp/reference/event/conference'

module TUPP
  class Reference
    class Publication
      class ConferencePaper < Publication
        attr_accessor :conference
      end
    end
  end
end
