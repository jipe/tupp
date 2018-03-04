require 'tupp/model'

shared_examples 'valid_publication' do
  it 'returns a TUPP::Reference::Publication' do
    expect(parsed_document).to be_a TUPP::Reference::Publication
  end
end
