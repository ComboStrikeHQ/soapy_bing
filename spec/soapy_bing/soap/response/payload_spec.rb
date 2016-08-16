# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::Payload do
  before do
    stub_const(
      'MyCustomResponse',
      Class
        .new
        .include(described_class)
    )
  end

  subject(:response) { MyCustomResponse.new }

  describe '#payload' do
    it 'memoize #extract_payload value' do
      expect(response).to receive(:extract_payload).once.and_return(true)
      2.times { response.payload }
    end
  end

  describe '#extract_payload' do
    it 'throws NotImplementedError' do
      expect { response.extract_payload }.to raise_error NotImplementedError
    end
  end
end
