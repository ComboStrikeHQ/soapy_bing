RSpec.describe SoapyBing::OauthCredentials do
  describe '#access_token' do
    context 'on successful respose', :integration do
      it 'responds with oauth access token',
        vcr: { cassette_name: 'oauth_credentials/access_token/with_successful_status' } do
        expect(subject.access_token).to eq 'bing-ads-oauth-authentication-token'
      end
    end
  end
end
