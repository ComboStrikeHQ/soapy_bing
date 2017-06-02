# frozen_string_literal: true
module SoapyBing
  class CampaignManagement
    attr_reader :service

    def initialize(*args)
      @service = Service.campaign_management(*args)
    end

    def get_geo_locations # rubocop:disable Style/AccessorMethodName
      response = service.get_geo_locations_file_url(
        version: '1.0',
        language_locale: 'en'
      )
      csv = HTTParty.get(response[:file_url]).body
      header, *body = CSV.parse(csv)
      body.map { |row| header.zip(row).to_h }
    end
  end
end
