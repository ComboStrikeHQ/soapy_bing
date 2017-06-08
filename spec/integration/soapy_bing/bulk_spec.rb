# frozen_string_literal: true

RSpec.describe SoapyBing::Bulk do
  subject(:service) { described_class.new }

  describe '#campaigns', :vcr do
    let(:fixtured_payload) do
      JSON.parse(File.read(File.join('spec', 'fixtures', 'bulk', 'campaigns.json')))
    end

    it 'returns parsed rows' do
      expect(service.campaigns(%w[Campaigns])).to eq fixtured_payload
    end
  end
end
