require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::Thesis < Reference::Publication
    def initialize(document = {})
      super(document)
    end
  end
end
