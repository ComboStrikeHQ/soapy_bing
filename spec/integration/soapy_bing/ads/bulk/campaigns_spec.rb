# frozen_string_literal: true
RSpec.describe SoapyBing::Ads::Bulk::Campaigns do
  let(:service) { SoapyBing::Ads.new }
  subject(:bulk_campaigns) { service.bulk_campaigns }

  describe '#rows' do
    let(:test_csv) { <<~CSV }
      a,b,c
      1,2,3
      x,,z
    CSV
    let(:zip_downloader) do
      instance_double(SoapyBing::Helpers::ZipDownloader, read: test_csv)
    end
    it 'returns an array of rows as hashes' do
      expect(SoapyBing::Helpers::ZipDownloader).to receive(:new).and_return(zip_downloader)
      expect(bulk_campaigns).to receive(:result_file_url)
      expect(bulk_campaigns.rows).to eq(
        [
          { 'a' => '1', 'b' => '2', 'c' => '3' },
          { 'a' => 'x', 'b' => nil, 'c' => 'z' }
        ]
      )
    end
  end

  describe '#result_file_url', :vcr do
    let(:result_file_url_template) do
      %r{https://bingadsappsstorageprod\.blob\.core\.windows\.net/bulkdownloadresultfiles/DownloadHierarchy.*\.zip\?.*} # rubocop:disable Metrics/LineLength
    end
    it 'returns result file url' do
      expect(bulk_campaigns.result_file_url).to match(result_file_url_template)
    end
  end
end
