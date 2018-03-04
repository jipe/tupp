require 'tupp/reference'

module TUPP
  class Reference::Publication < Reference
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

      self.language = document[:language]
    end
  end
end
