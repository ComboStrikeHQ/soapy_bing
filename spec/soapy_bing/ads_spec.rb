RSpec.describe SoapyBing::Ads do
  let(:oauth) do
    { client_id: 'foo', client_secret: 'bar', refresh_token: 'baz' }
  end
  let(:account) do
    { developer_token: 'foo', account_id: 'baz', customer_id: 'qux' }
  end
  subject { described_class.new(oauth: oauth, account: account) }

  describe '#oauth_credentials' do
    it 'is instance of SoapyBing::OauthCredentials' do
      expect(subject.oauth_credentials).to be_an_instance_of SoapyBing::OauthCredentials
    end
  end

  describe '#account' do
    it 'is instance of SoapyBing::Account' do
      expect(subject.account).to be_an_instance_of SoapyBing::Account
    end
  end

  describe '#campaign_performance_report' do
    subject do
      described_class
        .new(oauth: oauth, account: account)
        .campaign_performance_report(date_start: '2015-01-01', date_end: '2015-01-01')
    end
    it 'is instance of SoapyBing::Ads::Reports::CampaignPerformanceReport' do
      expect(subject).to be_an_instance_of SoapyBing::Ads::Reports::CampaignPerformanceReport
    end
  end
end
