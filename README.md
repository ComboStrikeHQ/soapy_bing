# SoapyBing
[![Circle CI](https://circleci.com/gh/ad2games/soapy_bing.png?style=shield)](https://circleci.com/gh/ad2games/soapy_bing)

Client library for [Bing Ads API](https://msdn.microsoft.com/en-us/library/bing-ads-overview)

## Installation

In your Gemfile

```ruby
gem 'soapy_bing', git: 'https://github.com/ad2games/soapy_bing'
```

## Usage Examples

```ruby
bing_ads = SoapyBing::Ads.new
report = bing_ads.campaign_performance_report(
  date_start: '2015-10-14',
  date_end: '2015-10-14',

  settings: {       # optional
    columns: ['']   # see SoapyBing::Ads::Report::Base::DEFAULT_REPORT_SETTINGS[:columns]
  }
)
report.rows # =>
            #     [{
            #       "GregorianDate" => "2015-10-14"
            #       "Hour"          => "0",
            #       "CampaignName"  => "My Campaign",
            #       "Impressions"   => "100",
            #       "Clicks"        => "47",
            #       "Spend"         => "12.65"
            #     }, {
            #       ...
            #     }]
```

## Authentication

Authentication attributes could be passed explicitly when new instance of SoapyBing::Ads is created.
Or they could be configured as Envronment variables.

```ruby
SoapyBing::Ads.new(
  oauth: {                  # optional, could be configured via environment variables as
    client_id: '',          # ENV['BING_ADS_OAUTH_CLIENT_ID']
    client_secret: '',      # ENV['BING_ADS_OAUTH_CLIENT_SECRET']
    refresh_token: ''       # ENV['BING_ADS_OAUTH_REFRESH_TOKEN']
  },
  account: {                # optional, could be configured via environment variables as
    developer_token: '',    # ENV['BING_ADS_DEVELOPER_TOKEN']
    account_id: '',         # ENV['BING_ADS_ACCOUNT_ID']
    customer_id: ''         # ENV['BING_ADS_CUSTOMER_ID']
  }
)
```

### Generate a refresh token

First go to the following url using your Client Id and Redirect Url.

    https://login.live.com/oauth20_authorize.srf?client_id=<YOUR_CLIENT_ID>&scope=bingads.manage&response_type=code&redirect_uri=<YOUR_REDIRECT_URL>&state=ClientStateGoesHere

Make a note of the code parameter that is present in the redirect url. Execute the following curl command to get a new Refresh token.

```sh
curl -v -XPOST \
  -d client_id=<YOUR_CLIENT_ID> \
  -d code=<THE_CODE_FROM_THE_FIRST_CALL>
  -d grant_type=authorization_code \
  -d redirect_uri=<YOUR_REDIRECT_URL> \
  -d client_secret=<YOUR_CLIENT_SECRET> \
  -H "Content-Type: application/x-www-form-urlencoded" \
  https://login.live.com/oauth20_token.srf
```

## Links
* MS Live Applications [https://account.live.com/developers/applications](https://account.live.com/developers/applications)
* Bing Ads User Authentication with OAuth [https://msdn.microsoft.com/en-us/library/bing-ads-user-authentication-oauth-guide.aspx](https://msdn.microsoft.com/en-us/library/bing-ads-user-authentication-oauth-guide.aspx)
* Getting Started With the Bing Ads API [https://msdn.microsoft.com/en-us/library/bing-ads-getting-started.aspx](https://msdn.microsoft.com/en-us/library/bing-ads-getting-started.aspx)
* Bing Ads API Reference [https://msdn.microsoft.com/en-US/library/bing-ads-api-reference.aspx](https://msdn.microsoft.com/en-US/library/bing-ads-api-reference.aspx)
* Reporting Service Reference [https://msdn.microsoft.com/en-US/library/bing-ads-reporting-service-reference](https://msdn.microsoft.com/en-US/library/bing-ads-reporting-service-reference)
