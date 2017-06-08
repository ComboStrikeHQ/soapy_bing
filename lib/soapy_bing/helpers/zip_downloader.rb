# frozen_string_literal: true

require 'httparty'
require 'zip'

module SoapyBing
  module Helpers
    class ZipDownloader
      def initialize(url)
        @url = url
      end

      def read
        Zip::InputStream.open(download_io) do |archive_io|
          file_io = archive_io.get_next_entry.get_input_stream
          file_io.read
        end
      end

      private

      def download_io
        StringIO.new HTTParty.get(@url).body
      end
    end
  end
end
