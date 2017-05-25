# frozen_string_literal: true
require 'json'
require 'csv'

RSpec.describe SoapyBing::Ads::Reports::Parsers::CSVParser do
  describe '#rows' do
    subject(:rows) { described_class.new(csv_data).rows }
    context 'on valid CSV data' do
      let(:csv_fixture_path) do
        File.join('spec', 'fixtures', 'reports', 'campaign_performance_report.csv')
      end
      let(:csv_data) { File.read(csv_fixture_path) }

      let(:json_fixture_path) do
        File.join('spec', 'fixtures', 'reports', 'campaign_performance_report.json')
      end
      let(:json_data) { JSON.parse(File.read(json_fixture_path)) }

      it 'responds with array of Hashes' do
        expect(rows).to eq json_data
      end
    end

    context 'on malformed CSV data' do
      let(:csv_data) { '"co", "' }

      it 'throws exception CSV::MalformedCSVError' do
        expect { rows }.to raise_error CSV::MalformedCSVError
      end
    end
  end
end
