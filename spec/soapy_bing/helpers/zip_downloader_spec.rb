# frozen_string_literal: true

RSpec.describe SoapyBing::Helpers::ZipDownloader do
  describe '#read' do
    let(:hello_zip_file_path) { File.join('spec', 'fixtures', 'helpers', 'hello.zip') }
    let(:hello_response) do
      instance_double(HTTParty::Response, body: File.read(hello_zip_file_path))
    end
    let(:download_url) { 'https://example.com/file.zip' }

    subject(:instance) { described_class.new(download_url) }

    it 'unzips and reads file content' do
      expect(HTTParty).to receive(:get).with(download_url).and_return(hello_response)
      expect(instance.read).to eq("Hello World\n")
    end
  end
end
