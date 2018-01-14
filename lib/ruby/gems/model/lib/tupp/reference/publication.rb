require 'tupp/reference'

module TUPP
  class Reference::Publication < Reference
    attr_accessor :authors,
                  :editors,
                  :publisher,
                  :publication_date,
                  :copyright,
                  :locations

    def initialize
      @authors   = []
      @editors   = []
      @locations = []
    end
  end
end
