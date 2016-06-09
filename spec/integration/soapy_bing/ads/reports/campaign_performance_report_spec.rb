# frozen_string_literal: true
require 'json'

RSpec.describe SoapyBing::Ads::Reports::CampaignPerformanceReport do
  let(:service) { SoapyBing::Ads.new }
  let(:report) do
    service.campaign_performance_report(
      date_start: '2015-10-14',
      date_end: '2015-10-14',
      # CampaignName is considered to be a sensitive data, lets not record it
      settings: { columns: %w(TimePeriod Impressions Clicks Spend) }
    )
  end
  let(:payload_fixture_path) do
    File.join('spec', 'fixtures', 'reports', 'campaign_performance_report.json')
  end
  let(:fixtured_payload) { JSON.load(File.read(payload_fixture_path)) }

  describe '#rows' do
    subject { report.rows }

    context 'when there is a successfull response during polling', :integration do
      it 'responds with report rows',
        vcr: { cassette_name: 'campaign_performance_report/with_successful_status' } do
        expect(subject).to eq fixtured_payload
      end
    end

    context 'when there is only pending responses during polling', :integration do
      before { stub_const('SoapyBing::Soap::Request::PollGenerateReportRequest::POLLING_TRIES', 1) }

      it 'throws exception PollingTimeoutError',
        vcr: { cassette_name: 'campaign_performance_report/with_pending_status' } do
        expect { subject }.to raise_error(
          SoapyBing::Soap::Request::PollGenerateReportRequest::PollingTimeoutError
        )
      end
    end
  end
end
