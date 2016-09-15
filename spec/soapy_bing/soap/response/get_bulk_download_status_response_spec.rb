# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::GetBulkDownloadStatusResponse do
  subject(:response) { described_class.new(response_hash) }

  describe '#payload' do
    context 'in progress status response' do
      let(:response_hash) do
        {
          'Envelope' => {
            'Body' => {
              'GetBulkDownloadStatusResponse' => {
                'Errors' => nil,
                'PercentComplete' => '42',
                'RequestStatus' => 'InProgress',
                'ResultFileUrl' => nil
              }
            }
          }
        }
      end

      it 'returns status and percent complete' do
        expect(response.payload).to include(
          'PercentComplete' => '42',
          'RequestStatus' => 'InProgress',
          'ResultFileUrl' => nil
        )
      end
    end

    context 'failed status response' do
      let(:response_hash) do
        {
          'Envelope' => {
            'Body' => {
              'GetBulkDownloadStatusResponse' => {
                'Errors' => [
                  'OperationError' => {
                    'Code' => '0',
                    'ErrorCode' => 'InternalError',
                    'Message' => 'An internal error has occurred'
                  }
                ],
                'PercentComplete' => '0',
                'RequestStatus' => 'Failed',
                'ResultFileUrl' => nil
              }
            }
          }
        }
      end

      it 'raises a StatusFailed exception with error message' do
        expect { response.payload }.to raise_error(
          described_class::StatusFailed, /An internal error has occurred/
        )
      end
    end
  end
end
