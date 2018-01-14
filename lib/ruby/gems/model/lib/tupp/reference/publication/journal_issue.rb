require 'tupp/reference/publication'

module TUPP
  class Reference::Publication::JournalIssue < Reference::Publication
    attr_accessor :journal, :volume, :issue

    def publisher
      journal.publisher
    end
  end
end
