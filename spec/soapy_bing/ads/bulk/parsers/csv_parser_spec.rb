# frozen_string_literal: true
require 'json'
require 'csv'

RSpec.describe SoapyBing::Ads::Bulk::Parsers::CSVParser do
  describe '#rows' do
    subject(:rows) { described_class.new(csv_data).rows }

    let(:csv_fixture_path) do
      File.join('spec', 'fixtures', 'bulk', 'campaigns.csv')
    end
    let(:csv_data) { File.read(csv_fixture_path) }

    let(:json_fixture_path) do
      File.join('spec', 'fixtures', 'bulk', 'campaigns.json')
    end
    let(:json_data) { JSON.load(File.read(json_fixture_path)) }

    it 'responds with array of Hashes' do
      expect(rows).to eq json_data
    end
  end
end
