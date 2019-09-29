require 'tupp'

module TUPP
  class Reference
    attr_accessor :identifiers,
                  :title,
                  :subtitle,
                  :normalized_title,
                  :normalized_subtitle,
                  :title_variants,
                  :grouping_key

    def initialize(document = {})
      @identifiers    = []
      @title_variants = []

      self.title               = document[:title]
      self.subtitle            = document[:subtitle]
      self.normalized_title    = document[:normalized_title]
      self.normalized_subtitle = document[:normalized_subtitle]
    end
  end
end
