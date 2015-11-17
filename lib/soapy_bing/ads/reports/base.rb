require 'ostruct'
require 'httparty'
require 'zip'

module SoapyBing
  class Ads
    module Reports
      class Base
        class UnknownParserError < StandardError; end
        include Helpers::ClassName

        DEFAULT_REPORT_SETTINGS = {
          format:      'Csv',
          language:    'English',
          name:        'MyReport',
          aggregation: 'HourOfDay',
          columns:     %w(TimePeriod CampaignName Impressions Clicks Spend)
        }.freeze

        attr_reader :oauth_credentials, :account, :settings

        def initialize(options)
          @oauth_credentials = options.fetch(:oauth_credentials)
          @account = options.fetch(:account)
          @settings = OpenStruct.new(DEFAULT_REPORT_SETTINGS.merge(options.fetch(:settings, {})))
        end

        def rows
          @rows ||= parser_class.new(report_body).rows
        end

        private

        def parser_class
          class_name = "#{settings.format.upcase}Parser".to_sym
          fail UnknownParserError, class_name unless Parsers.constants.include?(class_name)
          Parsers.const_get class_name
        end

        def download_url
          @url ||=
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

        def report_body
          @report_body ||=
            Zip::InputStream.open(download_io) do |archive_io|
              file_io = archive_io.get_next_entry.get_input_stream
              file_io.read
            end
        end

        def download_io
          StringIO.new HTTParty.get(download_url).body
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
