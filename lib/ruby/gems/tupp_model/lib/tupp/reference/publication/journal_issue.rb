require 'tupp/reference/publication'

module TUPP
  class Reference
    class Publication
      class JournalIssue < Publication
        attr_accessor :journal, :volume, :issue

        def publisher
          journal.publisher
        end
      end
    end
  end
end
