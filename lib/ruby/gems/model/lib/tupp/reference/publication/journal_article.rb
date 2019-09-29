require 'tupp/reference/publication'

module TUPP
  class JournalArticle < Publication
    attr_accessor :journal_issue, :pages

    def initialize(document = {})
      super(document)
    end
  end
end
