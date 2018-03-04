require 'tupp/model'

describe TUPP::Reference::Publication do
  it { is_expected.to be_a TUPP::Reference }

  describe '#initialize' do
    context 'with no arguments' do
      it 'initializes authors as an empty array' do
        expect(subject.authors).to be_an Array
        expect(subject.authors).to be_empty
      end

      it 'initializes editors as an empty array' do
        expect(subject.editors).to be_an Array
        expect(subject.editors).to be_empty
      end

      it 'initializes locations as an empty array' do
        expect(subject.locations).to be_an Array
        expect(subject.locations).to be_empty
      end
    end

    context 'with arguments' do
      it 'raises an error' do
        expect { TUPP::Reference::Publication.new({}) }.to raise_error(ArgumentError)
      end
    end
  end
end
