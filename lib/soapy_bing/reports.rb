# frozen_string_literal: true
require 'soapy_bing/reports/base'
require 'soapy_bing/reports/campaign_performance_report'

module SoapyBing
  class Reports
    attr_reader :service

    def initialize(*args)
      @service = Service.reporting(*args)
    end

    def campaign_performance_report(date_start:, date_end:, settings: {}, polling_settings: {})
      CampaignPerformanceReport.new(
        service: service,
        date_start: date_start,
        date_end: date_end,
        settings: settings,
        polling_settings: polling_settings
      ).rows
    end
  end
end
