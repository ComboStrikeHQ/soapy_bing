# frozen_string_literal: true
RSpec.describe SoapyBing::Account do
  describe '#initialize' do
    subject(:account_obj) { described_class.new(account) }

    context 'when account credentials passed explicitly' do
      let(:account) do
        { developer_token: 'foo', account_id: 'baz', customer_id: 'qux' }
      end
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_DEVELOPER_TOKEN').and_return('foo_env')
        allow(ENV).to receive(:[]).with('BING_ADS_ACCOUNT_ID').and_return('baz_env')
        allow(ENV).to receive(:[]).with('BING_ADS_CUSTOMER_ID').and_return('qux_env')
      end

      it '#developer_token is set' do
        expect(account_obj.developer_token).to eq 'foo'
      end

      it '#account_id is set' do
        expect(account_obj.account_id).to eq 'baz'
      end

      it '#customer_id is set' do
        expect(account_obj.customer_id).to eq 'qux'
      end
    end

    context 'when account credentials passed via Enviromenment variables' do
      let(:account) { {} }
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_DEVELOPER_TOKEN').and_return('foo_env')
        allow(ENV).to receive(:[]).with('BING_ADS_ACCOUNT_ID').and_return('baz_env')
        allow(ENV).to receive(:[]).with('BING_ADS_CUSTOMER_ID').and_return('qux_env')
      end

      it '#developer_token is set' do
        expect(account_obj.developer_token).to eq 'foo_env'
      end

      it '#account_id is set' do
        expect(account_obj.account_id).to eq 'baz_env'
      end

      it '#customer_id is set' do
        expect(account_obj.customer_id).to eq 'qux_env'
      end
    end

    context 'when no credentials passed' do
      let(:account) do
        { developer_token: 'foo', account_id: 'baz', customer_id: 'qux' }
      end
      before do
        %w( BING_ADS_DEVELOPER_TOKEN
            BING_ADS_ACCOUNT_ID
            BING_ADS_CUSTOMER_ID ).each do |var|
          allow(ENV).to receive(:[]).with(var).and_return(nil)
        end
      end

      it 'throws exception on missing :developer_token' do
        account.delete(:developer_token)
        expect { account_obj }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          "developer_token have to be passed explicitly or via ENV['BING_ADS_DEVELOPER_TOKEN']"
      end

      it 'throws exception on missing :account_id' do
        account.delete(:account_id)
        expect { account_obj }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          "account_id have to be passed explicitly or via ENV['BING_ADS_ACCOUNT_ID']"
      end

      it 'throws exception on missing :customer_id' do
        account.delete(:customer_id)
        expect { account_obj }.to raise_error SoapyBing::ParamGuard::ParamRequiredError,
          "customer_id have to be passed explicitly or via ENV['BING_ADS_CUSTOMER_ID']"
      end
    end
  end
end
