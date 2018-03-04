require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::ConferencePaper < Reference::Publication
    attr_accessor :conference

    def initialize(document = {})
      super(document)
    end
  end
end
