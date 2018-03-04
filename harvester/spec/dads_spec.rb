require 'tupp/xml/dads'
require 'tupp/model'

require 'dads/shared_examples_for_reference'
require 'dads/shared_examples_for_publication'

def valid_journal_article
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mods version="3.6" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink">
  <genre type="ds.dtic.dk:type:synthesized">bib:article:journal_article</genre>
  <genre type="ds.dtic.dk:type:origin">dja</genre>
	<language>
		<languageTerm type="code" authority="iso639-2b">eng</languageTerm>
  </language>
  <identifier type="doi">10.1002/12345678</identifier>
	<titleInfo>
		<title lang="eng">Journal Article Title</title>
		<subTitle lang="eng">Journal Article Subtitle</subTitle>
	</titleInfo>
	<titleInfo type="uniform" otherType="sort title">
		<title lang="eng">journal article normalized title</title>
		<subTitle lang="eng">journal article normalized subtitle</subTitle>
	</titleInfo>
  <name type="personal">
    <namePart type="given">First</namePart>
    <namePart type="family">Author</namePart>
    <role>
      <roleTerm type="code" authority="marcrelator">aut</roleTerm>
      <roleTerm type="text" authority="marcrelator">Author</roleTerm>
    </role>
    <affiliation>DTU Library, Technical University of Denmark</affiliation>
  </name>
</mods>
EOF
end

module TUPP::XML::DADS
  describe DocumentHandler do
    let(:handler) { DocumentHandler.new }
    
    subject(:parsed_document) { TUPP::XML.digest(xml, handler) }

    context 'when document is a valid journal article' do
      let(:xml) { valid_journal_article }

      include_examples 'valid_reference'
      include_examples 'valid_publication'

      it 'returns a TUPP::Reference::Publication::JournalArticle' do
        expect(parsed_document).to be_a TUPP::Reference::Publication::JournalArticle
      end

      it 'parses the article language' do
        expect(parsed_document.language).to eq 'eng'
      end

      it 'parses the article title' do
        expect(parsed_document.title).to eq 'The Awesome Journal'
      end

      it 'parses the normalized article title' do
        expect(parsed_document.normalized_title).to eq 'the awesome journal'
      end

      it 'parses the article authors'
    end
  end
end

