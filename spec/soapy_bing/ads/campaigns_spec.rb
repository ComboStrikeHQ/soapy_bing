# frozen_string_literal: true

RSpec.describe SoapyBing::Ads::Campaigns do
  subject(:campaigns) do
    described_class.new(
      service_options: {},
      polling_settings: polling_settings
    )
  end

  let(:service_double) { double }
  let(:account_double) { instance_double(SoapyBing::Account) }
  let(:zip_downloader_double) { instance_double(SoapyBing::Helpers::ZipDownloader) }
  let(:polling_settings) { {} }

  describe '#rows' do
    let(:completed_response) do
      {
        request_status: 'Completed',
        result_file_url: 'http://example.com/result_file'
      }
    end

    let(:pending_response) do
      {
        request_status: 'Pending'
      }
    end

    before do
      allow(SoapyBing::Service).to receive(:bulk).and_return(service_double)

      allow(SoapyBing::Helpers::ZipDownloader).to receive(:new)
        .with('http://example.com/result_file')
        .and_return(zip_downloader_double)

      allow(zip_downloader_double).to receive(:read)
        .and_return("a,b\nc,d\ne,f")

      allow(service_double).to receive(:download_campaigns_by_account_ids)
        .and_return(download_request_id: '123')

      allow(service_double).to receive(:account)
        .and_return(account_double)

      allow(account_double).to receive(:account_id).and_return(1)

      call_count = 0
      allow(service_double).to receive(:get_bulk_download_status) do
        call_count += 1
        call_count == 3 ? completed_response : pending_response
      end
    end

    it 'polls until successful response' do
      expect(campaigns.rows).to eq(
        [
          { 'a' => 'c', 'b' => 'd' },
          { 'a' => 'e', 'b' => 'f' }
        ]
      )
      expect(service_double).to have_received(:download_campaigns_by_account_ids).once
      expect(service_double).to have_received(:get_bulk_download_status).exactly(3).times
    end

    context 'with polling_tries = 1' do
      let(:polling_settings) { { tries: 1 } }

      it 'raises NotCompleted error after exceeded polling tries' do
        expect { campaigns.rows }.to raise_error described_class::NotCompleted
        expect(service_double).to have_received(:get_bulk_download_status).once
      end
    end

    context 'with failed response' do
      before do
        allow(service_double).to receive(:get_bulk_download_status) do
          {
            request_status: 'Failed',
            errors: {
              operation_error: {
                code: '0',
                error_code: 'InternalError',
                message: 'An internal error has occurred'
              }
            }
          }
        end
      end

      it 'raises StatusFailed with error message' do
        expect { campaigns.rows }.to raise_error described_class::StatusFailed do |error|
          expect(error.message).to match(/An internal error has occurred/)
        end
        expect(service_double).to have_received(:get_bulk_download_status).once
      end
    end
  end
end
