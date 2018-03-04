require 'tupp/identifier'

module TUPP
  class Identifier::DOI < Identifier
    def initialize(doi)
      super(type: :doi, value: doi)
    end

    def resolver_url
      "http://dx.doi.org/#{value}"
    end
  end
end
