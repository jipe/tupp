require 'tupp/model'

shared_examples 'valid_reference' do
  it 'returns a TUPP::Reference' do
    expect(parsed_document).to be_a TUPP::Reference
  end

  it 'parses the reference information' do
    expect(parsed_document.title).to eq 'reference title'
    expect(parsed_document.subtitle).to eq 'reference subtitle'
    expect(parsed_document.normalized_title).to eq 'reference sort title'
    expect(parsed_document.normalized_subtitle).to eq 'reference sort subtitle'
  end
end
