# frozen_string_literal: true

require 'date'

RSpec.describe SoapyBing::Ads::CampaignPerformanceReport do
  subject(:report) { described_class.new(report_options) }

  let(:report_options) { { service_options: {} } }
  let(:service_double) { double }

  describe '#initialize' do
    let(:wrong_date) { 'wrong_date' }

    context 'when there is a wrong date format' do
      before { report_options.merge!(date_start: wrong_date) }

      let(:start_date) { 'wrong_date' }

      it 'throws exception' do
        expect { report }.to raise_error(ArgumentError, 'invalid date')
      end
    end
  end

  describe '#date_range' do
    let(:date_start) { '2011-01-01' }
    let(:date_end) { '2015-12-31' }

    before { report_options.merge!(date_start: date_start, date_end: date_end) }

    it 'is instance of Range' do
      expect(report.date_range).to be_an_instance_of Range
    end

    context 'begin' do
      it 'keeps initialized value' do
        expect(report.date_range.begin).to eq Date.parse(date_start)
      end
    end

    context 'end' do
      it 'keeps initialized value' do
        expect(report.date_range.end).to eq Date.parse(date_end)
      end
    end
  end

  describe '#rows' do
    context 'with failed response' do
      let(:date) { '2016-09-15' }

      before do
        report_options.merge!(date_start: date, date_end: date)
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
