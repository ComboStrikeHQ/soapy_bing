# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::Payload do
  before do
    stub_const(
      'MyCustomResponse',
      Class.new(SoapyBing::Soap::Response::Base).include(described_class)
    )
  end

  let(:body) { {} }
  let(:response) { MyCustomResponse.new(body) }

  describe '#payload' do
    it 'memoize #extract_payload value' do
      expect(response).to receive(:extract_payload).once.and_return(true)
      2.times { response.payload }
    end

    context 'faulty response' do
      let(:body) do
        {
          'Envelope' => {
            'Body' => {
              'Fault' => {
                'FaultCode' => '123',
                'FaultMessage' => 'Fault Test'
              }
            }
          }
        }
      end
      let(:expected_error_message) do
        '{"FaultCode"=>"123", "FaultMessage"=>"Fault Test"}'
      end
      it 'raises a Fault exception with fault message' do
        expect { response.payload }.to raise_error(
          SoapyBing::Soap::Response::Payload::Fault, expected_error_message
        )
      end
    end
  end

  describe '#extract_payload' do
    it 'throws NotImplementedError' do
      expect { response.extract_payload }.to raise_error NotImplementedError
    end
  end
end
