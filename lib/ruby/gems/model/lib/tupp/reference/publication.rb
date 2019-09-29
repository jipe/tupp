require 'tupp/reference'

module TUPP
  class Publication < Reference
    attr_accessor :authors,
                  :editors,
                  :publisher,
                  :publication_date,
                  :copyright,
                  :locations,
                  :language

    def initialize(document = {})
      super(document)

      @authors   = []
      @editors   = []
      @locations = []

      @language = document[:language]
      
    end
  end
end
