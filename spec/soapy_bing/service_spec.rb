# frozen_string_literal: true

RSpec.describe SoapyBing::Service do
  subject(:service) { described_class.campaign_management }

  describe '#build' do
    context 'without options' do
      it 'creates service with default savon globals' do
        globals = service.savon_client.globals
        expect(globals[:element_form_default]).to eq(:qualified)
        expect(globals[:convert_request_keys_to]).to eq(:camelcase)
        expect(globals[:wsdl]).to end_with('campaign_management.wsdl')
        expect(globals[:namespaces]).to eq({})
      end
    end

    context 'with custom options' do
      subject(:service) { described_class.campaign_management(options) }

      let(:options) do
        {
          savon_globals: {
            namespaces: { 'this_is_a' => 'test' }
          }
        }
      end

      it 'creates service with default savon globals and user options' do
        globals = service.savon_client.globals
        expect(globals[:element_form_default]).to eq(:qualified)
        expect(globals[:convert_request_keys_to]).to eq(:camelcase)
        expect(globals[:wsdl]).to end_with('campaign_management.wsdl')
        expect(globals[:namespaces]).to eq('this_is_a' => 'test')
      end

      it 'doesnt modify options hash' do
        service.savon_client.globals
        expect(options).to eq(
          savon_globals: {
            namespaces: { 'this_is_a' => 'test' }
          }
        )
      end
    end
  end

  describe '#respond_to?' do
    it 'responds to service operations' do
      expect(service).to respond_to(:get_ads_by_ids)
    end

    it 'doest respond to anything' do
      expect(service).not_to respond_to(:answer_to_life_universe_and_everything)
    end
  end

  describe '.local_wsdl_path_for' do
    before do
      allow(ENV).to receive(:[]).and_call_original
    end

    context 'without BING_ADS_SANDBOX set to 1' do
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_SANDBOX').and_return(nil)
      end

      it 'returns the regular WSDL path' do
        expect(File.read(described_class.local_wsdl_path_for('reporting')))
          .to include('reporting.api.bingads.microsoft.com')
      end
    end

    context 'with BING_ADS_SANDBOX set to 1' do
      before do
        allow(ENV).to receive(:[]).with('BING_ADS_SANDBOX').and_return('1')
      end

      it 'returns the sandbox WSDL path' do
        expect(File.read(described_class.local_wsdl_path_for('reporting')))
          .to include('reporting.api.sandbox.bingads.microsoft.com')
      end
    end
  end
end
