# frozen_string_literal: true
require 'json'

RSpec.describe SoapyBing::Ads::Reports::CampaignPerformanceReport do
  let(:service) { SoapyBing::Ads.new }
  let(:date) { '2016-10-14' }
  let(:report) do
    service.campaign_performance_report(
      date_start: date,
      date_end: date,
      # CampaignName is considered to be a sensitive data, lets not record it
      settings: { columns: %w(TimePeriod Impressions Clicks Spend) }
    )
  end
  let(:payload_fixture_path) do
    File.join('spec', 'fixtures', 'reports', 'campaign_performance_report.json')
  end
  let(:fixtured_payload) { JSON.parse(File.read(payload_fixture_path)) }

  describe '#rows' do
    subject(:rows) { report.rows }
    context 'when there is a successful empty response during polling', :integration do
      it 'responds with empty report rows',
        vcr: { cassette_name: 'campaign_performance_report/with_successful_empty_response' } do
        expect(rows).to eq []
      end
    end

    context 'when there is a successful response during polling', :integration do
      let(:date) { '2017-05-14' }

      it 'responds with report rows',
        vcr: { cassette_name: 'campaign_performance_report/with_successful_response' } do
        expect(rows).to eq fixtured_payload
      end
    end

    context 'when there is only pending responses during polling', :integration do
      before { stub_const('SoapyBing::Soap::Request::PollGenerateReportRequest::POLLING_TRIES', 1) }

      it 'throws exception PollingTimeoutError',
        vcr: { cassette_name: 'campaign_performance_report/with_pending_status' } do
        expect { rows }.to raise_error(
          SoapyBing::Soap::Request::PollGenerateReportRequest::PollingTimeoutError
        )
      end
    end
  end
end
