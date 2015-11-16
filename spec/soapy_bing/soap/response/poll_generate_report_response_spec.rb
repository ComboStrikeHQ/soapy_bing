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
  let(:subject) { described_class.new(response_hash) }

  it 'includes ReportStatus' do
    expect(described_class.ancestors).to include SoapyBing::Soap::Response::ReportStatus
  end

  it '#extract_payload returns download url' do
    expect(subject.extract_payload).to eq url
  end
end
