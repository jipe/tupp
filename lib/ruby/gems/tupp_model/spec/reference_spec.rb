require 'tupp/model'

describe TUPP::Reference do
  describe '#initialize' do
    context 'with no argument' do
      it 'initializes identifiers as an empty array' do
        expect(subject.identifiers).to respond_to(:[])
        expect(subject.identifiers).to be_empty
      end

      it 'initializes title_variants as an empty array' do
        expect(subject.title_variants).to respond_to(:[])
        expect(subject.title_variants).to be_empty
      end
    end

    context 'with an argument' do
      it 'raises an error' do
        expect {TUPP::Reference.new(Object.new)}.to raise_error(StandardError)
      end
    end
  end
end
