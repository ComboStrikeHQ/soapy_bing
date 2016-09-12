# frozen_string_literal: true
RSpec.describe SoapyBing::Helpers::ZipDownloader do
  describe '#ssl_version' do
    let(:empty_zip_file_path) { File.join('spec', 'fixtures', 'helpers', 'empty.zip') }
    let(:empty_response) do
      instance_double(HTTParty::Response, body: File.read(empty_zip_file_path))
    end
    let(:download_url) { 'https://example.com/file.zip' }
    subject(:instance) do
      described_class.new(download_url)
    end

    context 'when DEFAULT_SSL_VERSION is available' do
      before do
        stub_const('OpenSSL::SSL::SSLContext::METHODS', [described_class::DEFAULT_SSL_VERSION])
      end

      it 'uses DEFAULT_SSL_VERSION' do
        expect(HTTParty).to receive(:get).with(
          download_url, ssl_version: described_class::DEFAULT_SSL_VERSION
        ).and_return(empty_response)
        instance.read
      end
    end

    context 'when DEFAULT_SSL_VERSION is not available' do
      before { stub_const('OpenSSL::SSL::SSLContext::METHODS', []) }

      it 'uses OpenSSL default version' do
        expect(HTTParty).to receive(:get).with(
          download_url, ssl_version: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version]
        ).and_return(empty_response)
        instance.read
      end
    end
  end
end
