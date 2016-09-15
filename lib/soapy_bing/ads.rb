# frozen_string_literal: true
require 'soapy_bing/ads/reports'
require 'soapy_bing/ads/bulk'

module SoapyBing
  class Ads
    attr_reader :oauth_credentials, :account

    def initialize(oauth: {}, account: {})
      @oauth_credentials = OauthCredentials.new(oauth)
      @account = Account.new(account)
    end

    def campaign_performance_report(date_start:, date_end:, settings: {})
      Reports::CampaignPerformanceReport.new(
        oauth_credentials: oauth_credentials,
        account: account,
        date_start: date_start,
        date_end: date_end,
        settings: settings
      )
    end

    def bulk_campaigns(entities = nil)
      Bulk::Campaigns.new(
        oauth_credentials: oauth_credentials,
        account: account,
        entities: entities
      )
    end

    def get_ad_groups_by_campaign_id(campaign_id)
      do_request(Soap::Request::GetAdGroupsByCampaignIdRequest, campaign_id: campaign_id)
    end

    def get_ads_by_ad_group_id(ad_group_id)
      do_request(Soap::Request::GetAdsByAdGroupIdRequest, ad_group_id: ad_group_id)
    end

    def get_targets_by_campaign_ids(campaign_ids)
      do_request(Soap::Request::GetTargetsByCampaignIdsRequest, campaign_ids: campaign_ids)
    end

    private

    def do_request(klass, options)
      klass.new(context: {
        account: account,
        authentication_token: oauth_credentials.access_token
      }.merge(options))
        .perform
        .payload
    end
  end
end
