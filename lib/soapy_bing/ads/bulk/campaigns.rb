# frozen_string_literal: true
module SoapyBing
  class Ads
    module Bulk
      class Campaigns
        include Helpers::SSLVersion

        DEFAULT_ENTITIES = %w(CampaignTargets Ads).freeze
        POLLING_TRIES = 30
        NotCompleted = Class.new(StandardError)

        attr_reader :oauth_credentials, :account, :entities, :status

        def initialize(options)
          @oauth_credentials = options.fetch(:oauth_credentials)
          @account = options.fetch(:account)
          @entities = options.fetch(:entities) || DEFAULT_ENTITIES
        end

        def rows
          @rows ||= Parsers::CSVParser.new(report_body).rows
        end

        def result_file_url
          @result_file_url ||= begin
            wait_status_complete
            status['ResultFileUrl']
          end
        end

        def fetch_status
          @status = Soap::Request::GetBulkDownloadStatusRequest
            .new(context: context.merge(request_id: download_request_id))
            .perform
            .payload
        end

        private

        def wait_status_complete
          Retryable.retryable(tries: POLLING_TRIES, on: NotCompleted) do
            fetch_status
            raise NotCompleted if status['RequestStatus'] != 'Completed'
          end
        end

        def report_body
          @report_body ||=
            Zip::InputStream.open(download_io) do |archive_io|
              file_io = archive_io.get_next_entry.get_input_stream
              file_io.read
            end
        end

        def download_io
          https = URI.parse(result_file_url).scheme == 'https'
          request_options = https ? { ssl_version: ssl_version } : {}
          StringIO.new HTTParty.get(result_file_url, request_options).body
        end

        def download_request_id
          @download_request_id ||= Soap::Request::DownloadCampaignsByAccountIdsRequest
            .new(context: context.merge(entities: entities))
            .perform
            .payload
        end

        def context
          {
            account: account,
            authentication_token: oauth_credentials.access_token
          }
        end
      end
    end
  end
end
