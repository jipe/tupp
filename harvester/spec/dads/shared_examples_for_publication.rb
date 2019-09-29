require 'tupp/model'

shared_examples 'valid_publication' do
  it 'returns a TUPP::Publication' do
    expect(parsed_document).to be_a TUPP::Publication
  end

  it 'parses the publication information' do
    expect(parsed_document.language).to eq 'eng'
    expect(parsed_document.authors).to eq [ TUPP::Person.new(first_name: 'first', last_name: 'author') ]
  end
end
