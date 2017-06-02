# frozen_string_literal: true
RSpec.describe SoapyBing::CountryCodes do
  subject(:country_codes) { described_class.new }

  describe '#code' do
    context 'valid country id' do
      let(:id) { 20 }

      it 'returns contry code' do
        expect(country_codes.code(id)).to eq('BR')
      end
    end

    context 'valid country id as string' do
      let(:id) { '20' }

      it 'returns contry code' do
        expect(country_codes.code(id)).to eq('BR')
      end
    end

    context 'valid state id' do
      let(:id) { 685 }

      it 'returns contry code' do
        expect(country_codes.code(id)).to eq('BR-RS')
      end
    end

    context 'invalid id' do
      let(:id) { 0 }

      it 'raises error' do
        expect { country_codes.code(id) }.to raise_error(KeyError)
      end
    end
  end
end
