require 'tupp/model'

FactoryBot.define do
  factory :valid_journal_article, class: TUPP::JournalArticle do
    identifiers { [ FactoryBot.build(:valid_doi) ] }
  end
end
