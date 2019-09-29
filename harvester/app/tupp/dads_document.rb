require 'tupp'

module TUPP::DADS
  class Document
    attr_accessor :synthesized_genre,
                  :origin_genre,
                  :title,
                  :subtitle,
                  :normalized_title,
                  :normalized_subtitle,
                  :language,
                  :dois,
                  :authors,
                  :editors,
                  :organisations,
  end
end
