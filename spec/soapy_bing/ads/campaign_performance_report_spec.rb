# frozen_string_literal: true

require 'date'

RSpec.describe SoapyBing::Ads::CampaignPerformanceReport do
  subject(:report) { described_class.new(report_options) }

  let(:report_options) do
    {
      service_options: {},
      date_start: date_start,
      date_end: date_end
    }
  end
  let(:service_double) { double }

  describe '#initialize' do
    context 'when there is a wrong date format' do
      let(:date_start) { 'wrong_date' }
      let(:date_end) { 'today' }

      it 'throws exception' do
        expect { report }.to raise_error(ArgumentError, 'invalid date')
      end
    end

    context 'with valid dates' do
      let(:date_start) { '2017-06-20' }
      let(:date_end) { '2017-06-21' }

      it 'sets default pooling settings' do
        polling_settings = report.polling_settings
        expect(polling_settings[:tries]).to eq(20)
        expect(polling_settings[:sleep].call(6)).to eq(64)
        expect(polling_settings[:sleep].call(7)).to eq(120)
      end
    end
  end

  describe '#rows' do
    context 'with failed response' do
      let(:date_start) { '2016-09-15' }
      let(:date_end) { '2016-09-15' }

      before do
        allow(SoapyBing::Service).to receive(:reporting).and_return(service_double)
        allow(service_double).to receive(:submit_generate_report) do
          { report_request_id: '123' }
        end
        allow(service_double).to receive(:poll_generate_report) do
          {
            report_request_status: { status: 'Error' }
          }
        end
      end

      it 'raises StatusFailed' do
        expect { report.rows }.to raise_error SoapyBing::Ads::StatusFailed
        expect(service_double).to have_received(:poll_generate_report).once
      end
    end
  end
end
