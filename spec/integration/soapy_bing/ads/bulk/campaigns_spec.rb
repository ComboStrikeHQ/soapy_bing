# frozen_string_literal: true
RSpec.describe SoapyBing::Ads::Bulk::Campaigns do
  let(:service) { SoapyBing::Ads.new }
  subject(:bulk_campaigns) { service.bulk_campaigns(%w(Campaigns)) }

  describe '#rows', :vcr do
    let(:fixtured_payload) do
      JSON.load(File.read(File.join('spec', 'fixtures', 'bulk', 'campaigns.json')))
    end

    it 'returns parsed rows' do
      expect(bulk_campaigns.rows).to eq fixtured_payload
    end
  end
end
