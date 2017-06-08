# frozen_string_literal: true

RSpec.describe SoapyBing::Accounts do
  describe '#customer_management' do
    subject(:accounts) { described_class.new }

    let(:accounts_list_response) do
      {
        accounts_info: {
          account_info: [
            { id: '123' },
            { id: '456' }
          ]
        }
      }
    end

    before do
      allow(accounts.service).to receive(:get_accounts_info).and_return(accounts_list_response)
    end

    it 'returns accounts list' do
      result = accounts.list

      expect(result.size).to eq(2)
      expect(result.first.account_id).to eq('123')
      expect(result.last.account_id).to eq('456')
    end

    context 'without BING_ADS_ACCOUNT_ID' do
      around do |example|
        original_bing_ads_account_id = ENV['BING_ADS_ACCOUNT_ID']
        ENV.delete('BING_ADS_ACCOUNT_ID')
        example.run
        ENV['BING_ADS_ACCOUNT_ID'] = original_bing_ads_account_id
      end

      it 'returns accounts list' do
        result = accounts.list

        expect(result.size).to eq(2)
        expect(result.first.account_id).to eq('123')
        expect(result.last.account_id).to eq('456')
      end
    end
  end
end
