# frozen_string_literal: true
RSpec.describe SoapyBing::CampaignManagement do
  subject(:campaign_management) { described_class.new }

  describe '#get_geo_locations', :vcr do
    it 'returns a list of geo_locations hashes' do
      rows = campaign_management.get_geo_locations
      expect(rows.size).to eq(5)
      expect(rows.first).to eq(
        'ID' => '1',
        'Code' => 'AL',
        'Display Name' => 'Albania',
        'Descriptor' => 'country/region',
        'Target Type' => 'Country',
        'Replaces' => nil,
        'Status' => 'Active',
        'AdWords Location ID' => '2008'
      )
    end
  end
end
