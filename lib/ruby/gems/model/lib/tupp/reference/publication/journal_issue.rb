require 'tupp/reference/publication'

module TUPP
  class JournalIssue < Publication
    attr_accessor :journal, :volume, :issue

    def initialize(document = {})
      super(document)
    end
  end
end
