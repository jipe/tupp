require 'tupp/reference/publication'

module TUPP
  class Book < Publication
    def initialize(document = {})
      super(document)
    end
  end
end
