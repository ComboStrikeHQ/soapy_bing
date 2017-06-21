# frozen_string_literal: true

require 'soapy_bing/ads/campaigns'
require 'soapy_bing/ads/campaign_performance_report'

module SoapyBing
  class Ads
    attr_reader :service_options

    def initialize(service_options = {})
      @service_options = service_options
    end

    def campaign_performance_report(date_start:, date_end:, settings: {}, polling_settings: {})
      CampaignPerformanceReport.new(
        service_options: service_options,
        date_start: date_start,
        date_end: date_end,
        settings: settings,
        polling_settings: polling_settings
      ).rows
    end

    def campaigns(entities = Campaigns::DEFAULT_ENTITIES, polling_settings: {}, campaign_ids: nil)
      Campaigns.new(
        service_options: service_options,
        entities: entities,
        polling_settings: polling_settings,
        campaign_ids: campaign_ids
      ).rows
    end
  end
end
