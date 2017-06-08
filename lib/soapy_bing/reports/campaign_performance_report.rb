# frozen_string_literal: true

require 'date'

module SoapyBing
  class Reports
    class CampaignPerformanceReport < Base
      attr_reader :date_range

      def initialize(options)
        super
        @date_range = Range.new(
          Date.parse(options.fetch(:date_start)),
          Date.parse(options.fetch(:date_end))
        )
      end

      def message
        {
          aggregation: settings.aggregation,
          columns: { campaign_performance_report_column: settings.columns },
          scope: scope,
          time: {
            custom_date_range_end: date_hash(date_range.end),
            custom_date_range_start: date_hash(date_range.begin)
          }
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
