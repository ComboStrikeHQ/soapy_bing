# frozen_string_literal: true
require 'ostruct'

module SoapyBing
  class Ads
    module Reports
      class Base
        class UnknownParserError < StandardError; end
        include Helpers::ClassName

        XML_NIL_VALUE = { 'i:nil' => 'true' }.freeze
        DEFAULT_REPORT_SETTINGS = {
          format:      'Csv',
          language:    'English',
          name:        'MyReport',
          aggregation: 'Hourly',
          columns:     %w(TimePeriod CampaignName Impressions Clicks Spend CampaignId)
        }.freeze

        attr_reader :oauth_credentials, :account, :settings

        def initialize(options)
          @oauth_credentials = options.fetch(:oauth_credentials)
          @account = options.fetch(:account)
          @settings = OpenStruct.new(DEFAULT_REPORT_SETTINGS.merge(options.fetch(:settings, {})))
        end

        def rows
          @rows ||= download_and_parse_rows
        end

        private

        def download_and_parse_rows
          # https://msdn.microsoft.com/en-us/library/bing-ads-api-migration-guide(v=msads.100).aspx#Report-Download-URL-and-Empty-Reports
          return [] if download_url == XML_NIL_VALUE
          parser_class.new(Helpers::ZipDownloader.new(download_url).read).rows
        end

        def parser_class
          class_name = "#{settings.format.upcase}Parser".to_sym
          raise UnknownParserError, class_name unless Parsers.constants.include?(class_name)
          Parsers.const_get class_name
        end

        def download_url
          @download_url ||=
            Soap::Request::PollGenerateReportRequest
              .new(context: poll_generate_report_context)
              .perform
              .payload
        end

        def poll_generate_report_context
          {
            account: account,
            authentication_token: oauth_credentials.access_token,
            request_id: request_id
          }
        end

        def request_id
          @request_id ||=
            Soap::Request::SubmitGenerateReportRequest
              .new(context: submit_generate_report_context)
              .perform
              .payload
        end

        def submit_generate_report_context
          {
            account: account,
            authentication_token: oauth_credentials.access_token,
            settings: settings,
            report_class: class_name
          }
        end
      end
    end
  end
end
