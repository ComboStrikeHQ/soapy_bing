# frozen_string_literal: true

require 'soapy_bing/bulk/parsers/csv_parser'

module SoapyBing
  class Bulk
    class Campaigns
      DEFAULT_ENTITIES = %w[CampaignTargetCriterions Ads].freeze
      DEFAULT_POLLING_SETTINGS = {
        tries: 20,
        sleep: ->(n) { n < 7 ? 2**n : 120 }
      }.freeze
      NotCompleted = Class.new(StandardError)
      StatusFailed = Class.new(StandardError)

      attr_reader :service, :entities, :polling_settings, :status

      def initialize(service:, entities: DEFAULT_ENTITIES, polling_settings: {})
        @service = service
        @entities = entities
        @polling_settings = DEFAULT_POLLING_SETTINGS.merge(polling_settings)
      end

      def rows
        @rows ||= Parsers::CSVParser.new(Helpers::ZipDownloader.new(result_file_url).read).rows
      end

      private

      def result_file_url
        @result_file_url ||= begin
          wait_status_complete
          status[:result_file_url]
        end
      end

      def fetch_status
        response = service.get_bulk_download_status(request_id: download_request_id)
        if response[:request_status] == 'Failed'
          raise StatusFailed, response[:errors].to_s
        end
        @status = response.slice(:percent_complete, :request_status, :result_file_url)
      end

      def wait_status_complete
        Retryable.retryable(polling_settings.merge(on: NotCompleted)) do
          fetch_status
          raise NotCompleted if status[:request_status] != 'Completed'
        end
      end

      def download_request_id
        response = service.download_campaigns_by_account_ids(
          account_ids: {
            '@xmlns:a1' => 'http://schemas.microsoft.com/2003/10/Serialization/Arrays',
            'a1:long' => service.account.account_id
          },
          download_entities: { download_entity: entities },
          download_file_type: 'Csv',
          format_version: '5.0'
        )
        response[:download_request_id]
      end
    end
  end
end
