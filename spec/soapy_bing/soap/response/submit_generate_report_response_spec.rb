# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::SubmitGenerateReportResponse do
  let(:request_id) { 'foobarbazqux' }
  let(:response_hash) do
    {
      'Envelope' => {
        'Body' => {
          'SubmitGenerateReportResponse' => {
            'ReportRequestId' => request_id
          }
        }
      }
    }
  end
  subject(:response) { described_class.new(response_hash) }

  it '#extract_payload returns request id' do
    expect(response.extract_payload).to eq request_id
  end
end
