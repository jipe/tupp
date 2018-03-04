require 'tupp/model'

shared_examples 'valid_reference' do
  it 'returns a TUPP::Reference' do
    expect(parsed_document).to be_a TUPP::Reference
  end
end
