# frozen_string_literal: true
module SoapyBing
  class Ads
    module Bulk
      class Campaigns
        DEFAULT_ENTITIES = %w(CampaignTargetCriterions Ads).freeze
        DEFAULT_POLLING_SETTINGS = {
          tries: 20,
          sleep: ->(n) { n < 7 ? 2**n : 120 }
        }.freeze
        NotCompleted = Class.new(StandardError)

        attr_reader :oauth_credentials, :account, :entities, :polling_settings, :status

        def initialize(options)
          @oauth_credentials = options.fetch(:oauth_credentials)
          @account = options.fetch(:account)
          @entities = options.fetch(:entities) || DEFAULT_ENTITIES
          @polling_settings = DEFAULT_POLLING_SETTINGS.merge(options.fetch(:polling_settings) || {})
        end

        def rows
          @rows ||= Parsers::CSVParser.new(Helpers::ZipDownloader.new(result_file_url).read).rows
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
          Retryable.retryable(polling_settings.merge(on: NotCompleted)) do
            fetch_status
            raise NotCompleted if status['RequestStatus'] != 'Completed'
          end
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
