require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::JournalArticle < Reference::Publication
    attr_accessor :journal_issue, :pages
  end
end
