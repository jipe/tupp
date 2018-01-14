require 'tupp'

module TUPP
  class Reference
    attr_accessor :identifiers, :title, :title_variants

    def initialize
      @identifiers    = []
      @title_variants = []
    end
  end
end
