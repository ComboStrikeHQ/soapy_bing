# frozen_string_literal: true
require 'uri'
require 'httparty'
require 'zip'

module SoapyBing
  module Helpers
    class ZipDownloader
      DEFAULT_SSL_VERSION = :TLSv1

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
        https = URI.parse(@url).scheme == 'https'
        request_options = https ? { ssl_version: ssl_version } : {}
        StringIO.new HTTParty.get(@url, request_options).body
      end

      def ssl_version
        if OpenSSL::SSL::SSLContext::METHODS.include? DEFAULT_SSL_VERSION
          DEFAULT_SSL_VERSION
        else
          OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version]
        end
      end
    end
  end
end
