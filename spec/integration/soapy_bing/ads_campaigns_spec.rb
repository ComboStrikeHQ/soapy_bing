# frozen_string_literal: true

RSpec.describe SoapyBing::Ads do
  subject(:ads) { described_class.new }

  describe '#campaigns', :vcr do
    let(:entities) { %w[Campaigns] }
    let(:fixtured_payload) do
      JSON.parse(File.read(File.join('spec', 'fixtures', 'ads', 'campaigns.json')))
    end

    it 'returns parsed rows' do
      expect(ads.campaigns(entities)).to eq fixtured_payload
    end
  end

  describe '#campaign_performance_report' do
    let(:date) { '2016-10-14' }
    let(:settings) do
      # CampaignName is considered to be a sensitive data, lets not record it
      { columns: %w[TimePeriod Impressions Clicks Spend] }
    end
    let(:polling_settings) { {} }
    let(:params) do
      {
        date_start: date,
        date_end: date,
        settings: settings,
        polling_settings: polling_settings
      }
    end
    let(:fixtured_payload) do
      JSON.parse(
        File.read(
          File.join('spec', 'fixtures', 'ads', 'campaign_performance_report.json')
        )
      )
    end

    context 'when there is a successful empty response during polling' do
      it 'responds with empty report rows',
        vcr: { cassette_name: 'campaign_performance_report/with_successful_empty_response' } do
        expect(ads.campaign_performance_report(params)).to eq []
      end
    end

    context 'when there is a successful response during polling' do
      let(:date) { '2017-05-14' }

      it 'responds with report rows',
        vcr: { cassette_name: 'campaign_performance_report/with_successful_response' } do
        expect(ads.campaign_performance_report(params)).to eq fixtured_payload
      end
    end

    context 'when there is only pending responses during polling' do
      let(:polling_settings) { { tries: 1 } }

      it 'throws exception PollingTimeoutError',
        vcr: { cassette_name: 'campaign_performance_report/with_pending_status' } do
        expect { ads.campaign_performance_report(params) }.to(
          raise_error(SoapyBing::Ads::NotCompleted)
        )
      end
    end
  end
end
