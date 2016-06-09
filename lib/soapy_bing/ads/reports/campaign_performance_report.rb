# frozen_string_literal: true
require 'date'

module SoapyBing
  class Ads
    module Reports
      class CampaignPerformanceReport < Base
        attr_reader :date_range

        def initialize(options)
          super(options)
          @date_range = Range.new(
            Date.parse(options.fetch(:date_start)),
            Date.parse(options.fetch(:date_end))
          )
        end

        def submit_generate_report_context
          super.merge(date_range: date_range)
        end
      end
    end
  end
end
