require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::Book < Reference::Publication
    def initialize(document = {})
      super(document)
    end
  end
end
