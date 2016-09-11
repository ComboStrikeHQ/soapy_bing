# frozen_string_literal: true
RSpec.describe SoapyBing::Ads::Bulk::Campaigns do
  let(:service) { SoapyBing::Ads.new }
  subject(:bulk_campaigns) { service.bulk_campaigns }

  describe '#result_file_url', :vcr do
    let(:result_file_url_template) do
      %r{https://bingadsappsstorageprod\.blob\.core\.windows\.net/bulkdownloadresultfiles/DownloadHierarchy.*\.zip\?.*} # rubocop:disable Metrics/LineLength
    end
    it 'returns result file url' do
      expect(bulk_campaigns.result_file_url).to match(result_file_url_template)
    end
  end
end
