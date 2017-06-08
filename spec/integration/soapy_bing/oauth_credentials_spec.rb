# frozen_string_literal: true

RSpec.describe SoapyBing::OauthCredentials do
  subject(:oauth_credentials) { described_class.new }

  describe '#access_token' do
    context 'on successful respose', :integration do
      it 'responds with oauth access token',
        vcr: { cassette_name: 'oauth_credentials/access_token/with_successful_status' } do
        expect(oauth_credentials.access_token).to eq 'bing-ads-oauth-authentication-token'
      end
    end
  end
end
