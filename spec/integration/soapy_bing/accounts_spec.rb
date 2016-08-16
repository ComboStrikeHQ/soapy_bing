# frozen_string_literal: true
RSpec.describe SoapyBing::Accounts do
  subject(:instance) { described_class.new }

  describe '#list', :vcr do
    subject { instance.list }

    it 'returns a list of SoapyBing::Account objects' do
      expect(subject.size).to eq(3)
      expect(subject).to all(be_an_instance_of(SoapyBing::Account))
    end
  end
end
