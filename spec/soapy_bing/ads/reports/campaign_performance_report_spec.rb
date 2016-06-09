# frozen_string_literal: true
require 'date'

RSpec.describe SoapyBing::Ads::Reports::CampaignPerformanceReport do
  let(:report_options) { { oauth_credentials: nil, account: nil } }
  subject { described_class.new report_options }

  describe '#initialize' do
    let(:wrong_date) { 'wrong_date' }

    context 'when there is a wrong date format' do
      before { report_options.merge!(date_start: wrong_date) }

      let(:start_date) { 'wrong_date' }
      it 'throws exception' do
        expect { subject }.to raise_error(ArgumentError, 'invalid date')
      end
    end
  end

  describe '#date_range' do
    let(:date_start) { '2011-01-01' }
    let(:date_end) { '2015-12-31' }
    before { report_options.merge!(date_start: date_start, date_end: date_end) }

    it 'is instance of Range' do
      expect(subject.date_range).to be_an_instance_of Range
    end

    context 'begin' do
      it 'keeps initialized value' do
        expect(subject.date_range.begin).to eq Date.parse(date_start)
      end
    end

    context 'end' do
      it 'keeps initialized value' do
        expect(subject.date_range.end).to eq Date.parse(date_end)
      end
    end
  end
end
