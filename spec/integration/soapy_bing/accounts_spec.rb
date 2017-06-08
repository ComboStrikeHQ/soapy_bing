# frozen_string_literal: true

RSpec.describe SoapyBing::Accounts do
  subject(:instance) { described_class.new }

  describe '#list', :vcr do
    subject(:list) { instance.list }

    it 'returns a list of SoapyBing::Account objects' do
      expect(list.size).to eq(3)
      expect(list).to all(be_an_instance_of(SoapyBing::Account))
    end
  end
end
