# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::PollGenerateReportResponse do
  let(:url) { 'http://my-site.com' }
  let(:response_hash) do
    {
      'Envelope' => {
        'Body' => {
          'PollGenerateReportResponse' => {
            'ReportRequestStatus' => {
              'ReportDownloadUrl' => url
            }
          }
        }
      }
    }
  end
  subject(:response) { described_class.new(response_hash) }

  it 'includes ReportStatus' do
    expect(described_class.ancestors).to include SoapyBing::Soap::Response::ReportStatus
  end

  it '#extract_payload returns download url' do
    expect(response.extract_payload).to eq url
  end
end
