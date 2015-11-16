require 'soapy_bing/ads/reports'

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
  end
end
