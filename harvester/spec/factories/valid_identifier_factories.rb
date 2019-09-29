require 'tupp/model'

FactoryBot.define do
  factory :valid_doi, class: TUPP::Identifier do
    type { 'doi' }
    value { '10.1001/example-doi' }
  end
end
