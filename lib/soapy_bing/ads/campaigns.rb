# frozen_string_literal: true

require 'soapy_bing/ads/parsers/bulk_csv_parser'

module SoapyBing
  class Ads
    class Campaigns
      DEFAULT_ENTITIES = %w[CampaignTargetCriterions Ads].freeze
      DEFAULT_POLLING_SETTINGS = {
        tries: 20,
        sleep: ->(n) { n < 7 ? 2**n : 120 }
      }.freeze
      NotCompleted = Class.new(StandardError)
      StatusFailed = Class.new(StandardError)

      attr_reader :service, :entities, :polling_settings, :status, :campaign_ids

      def initialize(
        service_options:,
        entities: DEFAULT_ENTITIES,
        polling_settings: {},
        campaign_ids: nil
      )
        @service = Service.bulk(service_options)
        @entities = entities
        @polling_settings = DEFAULT_POLLING_SETTINGS.merge(polling_settings)
        @campaign_ids = campaign_ids
      end

      def rows
        @rows ||= Parsers::BulkCsvParser.new(Helpers::ZipDownloader.new(result_file_url).read).rows
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
        response = campaign_ids ? by_campaign_ids : by_account_ids
        response[:download_request_id]
      end

      def by_campaign_ids
        service.download_campaigns_by_campaign_ids(
          {
            campaigns: {
              campaign_scope: campaign_scope
            }
          }.merge(common_request_body)
        )
      end

      def campaign_scope
        campaign_ids.map do |campaign_id|
          {
            campaign_id: campaign_id,
            parent_account_id: service.account.account_id
          }
        end
      end

      def by_account_ids
        service.download_campaigns_by_account_ids(
          {
            account_ids: {
              '@xmlns:a1' => 'http://schemas.microsoft.com/2003/10/Serialization/Arrays',
              'a1:long' => service.account.account_id
            }
          }.merge(common_request_body)
        )
      end

      def common_request_body
        {
          download_entities: { download_entity: entities },
          download_file_type: 'Csv',
          format_version: '5.0'
        }
      end
    end
  end
end
