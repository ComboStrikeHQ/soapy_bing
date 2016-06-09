# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::Base do
  before { stub_const('MyCustomResponse', Class.new(described_class) {}) }
  let(:response_body) { 'Some response body' }
  let(:my_custom_response) { MyCustomResponse.new(response_body) }

  describe '#body' do
    subject { my_custom_response.body }
    it 'keeps initialized value' do
      expect(subject).to eq response_body
    end
  end
end
