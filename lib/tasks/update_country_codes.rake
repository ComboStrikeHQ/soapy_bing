# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.local', '.env')
require 'soapy_bing'

desc 'Fetch country codes from geo_locations API and update country_codes.yml file'
task :update_country_codes do
  TARGET_TYPES = %w[Country State].freeze

  campaign_management = SoapyBing::CampaignManagement.new
  rows = campaign_management.get_geo_locations

  rows.select! { |row| TARGET_TYPES.include?(row['Target Type']) }
  rows.map! { |row| row.slice('ID', 'Code') }

  country_codes = rows.each_with_object({}) do |row, hash|
    hash[row['ID']] = row['Code']
  end

  File.open(SoapyBing::CountryCodes::YML_FILE_PATH, 'wb') do |file|
    file.write country_codes.to_yaml
  end
end
