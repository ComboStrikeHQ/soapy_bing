# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Request::PollGenerateReportRequest do
  describe '#perform' do
    let(:response_body) do
      {
        'Envelope' => {
          'Body' => {
            'PollGenerateReportResponse' => {
              'ReportRequestStatus' => {
                'Status' => nil,
                'ReportDownloadUrl' => 'http://example.com'
              }
            }
          }
        }
      }
    end

    let(:pending_response_body) do
      response_body['Envelope']['Body']['PollGenerateReportResponse'] \
        ['ReportRequestStatus']['Status'] = 'Pending'
      response_body
    end
    let(:successful_response_body) do
      response_body['Envelope']['Body']['PollGenerateReportResponse'] \
        ['ReportRequestStatus']['Status'] = 'Success'
      response_body
    end

    before do
      call_count = 0
      allow(HTTParty).to receive(:post) do
        call_count += 1
        call_count == 3 ? successful_response_body : pending_response_body
      end
    end

    subject do
      described_class
        .new(
          context: {
            oauth: instance_double(SoapyBing::OauthCredentials).as_null_object,
            account: instance_double(SoapyBing::Account).as_null_object
          }
        )
        .perform
    end

    it 'polls until successful response' do
      expect(HTTParty).to receive(:post).exactly(3).times
      expect(subject.payload).to eq 'http://example.com'
    end

    it 'throws PollingTimeoutError when exceeded polling tries' do
      stub_const('SoapyBing::Soap::Request::PollGenerateReportRequest::POLLING_TRIES', 1)
      expect(HTTParty).to receive(:post).once
      expect { subject }.to raise_error described_class::PollingTimeoutError
    end
  end
end
