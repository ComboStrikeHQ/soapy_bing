# frozen_string_literal: true

require 'soapy_bing/ads/report'
require 'date'

module SoapyBing
  class Ads
    class CampaignPerformanceReport < Report
      attr_reader :date_start, :date_end

      def initialize(options)
        super
        @date_start = Date.parse(options.fetch(:date_start))
        @date_end = Date.parse(options.fetch(:date_end))
      end

      def message
        {
          aggregation: settings.aggregation,
          columns: { campaign_performance_report_column: settings.columns },
          scope: scope,
          time: {
            custom_date_range_end: date_hash(date_end),
            custom_date_range_start: date_hash(date_start)
          },
          report_time_zone: settings.report_time_zone
        }
      end

      private

      def scope
        {
          account_ids: {
            '@xmlns:a1' => 'http://schemas.microsoft.com/2003/10/Serialization/Arrays',
            'a1:long' => service.account.account_id
          }
        }
      end

      def date_hash(date)
        { day: date.day, month: date.month, year: date.year }
      end

      def request_type
        'CampaignPerformanceReportRequest'
      end
    end
  end
end
