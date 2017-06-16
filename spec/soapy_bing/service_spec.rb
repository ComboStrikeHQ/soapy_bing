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
      expect(service.respond_to?(:get_ads_by_ids)).to be_truthy
    end

    it 'doest respond to anything' do
      expect(service.respond_to?(:answer_to_life_universe_and_everything)).to be_falsey
    end
  end
end
