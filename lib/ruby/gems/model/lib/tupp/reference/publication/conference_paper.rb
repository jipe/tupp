require 'tupp/reference/publication'

module TUPP
  class ConferencePaper < Publication
    attr_accessor :conference

    def initialize(document = {})
      super(document)
    end
  end
end
