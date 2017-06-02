# frozen_string_literal: true
RSpec.describe SoapyBing::Service do
  subject(:service) { described_class.campaign_management }

  describe '#respond_to?' do
    it 'responds to service operations' do
      expect(service.respond_to?(:get_ads_by_ids)).to be_truthy
    end

    it 'doest respond to anything' do
      expect(service.respond_to?(:answer_to_life_universe_and_everything)).to be_falsey
    end
  end
end
