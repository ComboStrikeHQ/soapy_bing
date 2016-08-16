# frozen_string_literal: true
RSpec.describe SoapyBing::OauthCredentials do
  subject(:oauth_credentials) { described_class.new(credentials) }

  describe '#initialize' do
    context 'when oauth credentials passed explicitly' do
      let(:credentials) { { client_id: 'foo', client_secret: 'bar', refresh_token: 'baz' } }
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_CLIENT_ID').and_return('foo_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_CLIENT_SECRET').and_return('bar_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_REFRESH_TOKEN').and_return('baz_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_TOKEN_URL')
      end

      it '#client_id is set' do
        expect(oauth_credentials.client_id).to eq 'foo'
      end

      it '#client_secret is set' do
        expect(oauth_credentials.client_secret).to eq 'bar'
      end

      it '#refresh_token is set' do
        expect(oauth_credentials.refresh_token).to eq 'baz'
      end
    end

    context 'when oauth credentials passed via Enviromenment variables' do
      let(:credentials) { {} }
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_CLIENT_ID').and_return('foo_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_CLIENT_SECRET').and_return('bar_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_REFRESH_TOKEN').and_return('baz_env')
        allow(ENV).to receive(:[]).with('BING_ADS_OAUTH_TOKEN_URL')
      end

      it '#client_id is set' do
        expect(oauth_credentials.client_id).to eq 'foo_env'
      end

      it '#client_secret is set' do
        expect(oauth_credentials.client_secret).to eq 'bar_env'
      end

      it '#refresh_token is set' do
        expect(oauth_credentials.refresh_token).to eq 'baz_env'
      end
    end

    context 'when no oauth credentials passed' do
      let(:credentials) { { client_id: 'foo', client_secret: 'bar', refresh_token: 'baz' } }
      before do
        %w( BING_ADS_OAUTH_CLIENT_ID
            BING_ADS_OAUTH_CLIENT_SECRET
            BING_ADS_OAUTH_REFRESH_TOKEN ).each do |var|
          allow(ENV).to receive(:[]).with(var).and_return(nil)
        end
      end

      it 'throws exception on missing :client_id' do
        credentials.delete(:client_id)
        expect { oauth_credentials }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          'client_id have to be passed explicitly or via ENV[\'BING_ADS_OAUTH_CLIENT_ID\']'
      end

      it 'throws exception on missing :client_secret' do
        credentials.delete(:client_secret)
        expect { oauth_credentials }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          'client_secret have to be passed explicitly or via ENV[\'BING_ADS_OAUTH_CLIENT_SECRET\']'
      end

      it 'throws exception on missing :refresh_token' do
        credentials.delete(:refresh_token)
        expect { oauth_credentials }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          'refresh_token have to be passed explicitly or via ENV[\'BING_ADS_OAUTH_REFRESH_TOKEN\']'
      end
    end
  end

  describe '#access_token' do
    let(:credentials) { { client_id: 'foo', client_secret: 'bar', refresh_token: 'baz' } }
    let(:response) { double(:response) } # rubocop:disable RSpec/VerifiedDoubles

    before do
      expect(response).to receive(:code).once.and_return(status_code)
      expect(HTTParty).to receive(:post).once.and_return(response)
    end

    context 'when there is good response' do
      let(:status_code) { 200 }

      before { expect(response).to receive(:[]).once.with('access_token').and_return('my-token') }

      it 'memoizes http request response' do
        2.times { expect(oauth_credentials.access_token).to eq 'my-token' }
      end
    end

    context 'when there is bad response' do
      let(:status_code) { 401 }

      it 'throws exception in case of bad status code' do
        expect { oauth_credentials.access_token }.to raise_error(
          SoapyBing::OauthCredentials::TokenRefreshError
        )
      end
    end
  end
end
