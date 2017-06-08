# frozen_string_literal: true
require 'ostruct'
require 'soapy_bing/reports/parsers/csv_parser'

module SoapyBing
  class Reports
    NotCompleted = Class.new(StandardError)
    StatusFailed = Class.new(StandardError)

    class Base
      DEFAULT_REPORT_SETTINGS = {
        format:      'Csv',
        language:    'English',
        name:        'MyReport',
        aggregation: 'Hourly',
        columns:     %w(TimePeriod CampaignName Impressions Clicks Spend CampaignId)
      }.freeze

      DEFAULT_POLLING_SETTINGS = {
        tries: 20,
        sleep: ->(n) { n < 7 ? 2**n : 120 }
      }.freeze

      attr_reader :service, :settings, :polling_settings, :status

      def initialize(options)
        @service = options.fetch(:service)
        @settings = OpenStruct.new(DEFAULT_REPORT_SETTINGS.merge(options.fetch(:settings, {})))
        @polling_settings = DEFAULT_POLLING_SETTINGS.merge(options.fetch(:polling_settings, {}))
      end

      def rows
        @rows ||= download_and_parse_rows
      end

      private

      def download_and_parse_rows
        # https://msdn.microsoft.com/en-us/library/bing-ads-api-migration-guide(v=msads.100).aspx#Report-Download-URL-and-Empty-Reports
        return [] unless download_url
        Parsers::CSVParser.new(Helpers::ZipDownloader.new(download_url).read).rows
      end

      def download_url
        @download_url ||= begin
          wait_status_complete
          status[:report_download_url]
        end
      end

      def fetch_status
        response = service.poll_generate_report(report_request_id: report_request_id)
        if response[:report_request_status][:status] == 'Error'
          raise StatusFailed, response[:errors].to_s
        end
        @status = response[:report_request_status].slice(:status, :report_download_url)
      end

      def wait_status_complete
        Retryable.retryable(polling_settings.merge(on: NotCompleted)) do
          fetch_status
          raise NotCompleted if status[:status] != 'Success'
        end
      end

      def report_request_id
        response = service.submit_generate_report do |namespace_identifier|
          {
            report_request: {
              '@xsi:type' => "#{namespace_identifier}:#{request_type}"
            }.merge(base_message).merge(message)
          }
        end
        response[:report_request_id]
      end

      def base_message
        {
          # https://msdn.microsoft.com/en-us/library/bing-ads-reporting-campaignperformancereportrequest.aspx#Anchor_2
          format: settings.format,
          language: settings.language,
          report_name: settings.name,
          return_only_completed_data: false
        }
      end
    end
  end
end
