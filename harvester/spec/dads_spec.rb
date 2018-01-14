require 'tupp/xml/dads'
require 'tupp/model'

module TUPP::XML::DADS
  describe DocumentHandler do
    context 'when documents is a valid journal article' do
      let(:handler) { DocumentHandler.new }
      let(:xml)     { dads_document }

      before { ::TUPP::XML.digest(xml, handler) }

      subject { handler.document }

      it { is_expected.to be_a TUPP::Reference }
      it { is_expected.to be_a TUPP::Reference::Publication }
      it { is_expected.to be_a TUPP::Reference::Publication::JournalArticle }

      it 'works' do
        puts handler.document
      end
    end
  end
end

def dads_document
<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mods xmlns="http://www.loc.gov/mods/v3" version="3.6">
  <genre type="ds.dtic.dk:type:synthesized">bib:article:journal_article</genre>
  <genre type="ds.dtic.dk:type:origin">dja</genre>
  <titleInfo>
    <title>Document Title</title>
    <subTitle>Document Subtitle</subTitle>
  </titleInfo>
  <name type="personal">
    <namePart>Jimmy</namePart>
    <namePart>Petersen</namePart>
  </name>
</mods>
EOF
end
