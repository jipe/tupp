require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::ConferencePaper < Reference::Publication
    attr_accessor :conference
  end
end
