require 'tupp/xml/dads'
require 'tupp/model'

require 'dads/shared_examples_for_reference'
require 'dads/shared_examples_for_publication'

def load_fixture(name)
  IO.read("../spec/fixtures/dads/#{name}.xml", encoding: 'UTF-8')
end

module TUPP::XML::DADS
  describe DocumentHandler do
    let(:handler) { DocumentHandler.new }
    
    subject(:parsed_document) { TUPP::XML.digest(xml, handler) }

    context 'when document is a valid journal article' do
      let!(:xml) { load_fixture(:valid_journal_article) }
      let!(:expected_document) { FactoryBot.build(:valid_journal_article) }

      include_examples 'valid_reference'
      include_examples 'valid_publication'

      it 'returns a TUPP::JournalArticle' do
        expect(parsed_document).to be_a TUPP::JournalArticle
      end
    end
  end
end

