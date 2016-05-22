require 'tupp/identifier'

module TUPP
  class Identifier
    class DOI
      def initialize *args
        super
      end

      def resolver_url
        "http://dx.doi.org/#{value}"
      end
    end
  end
end
