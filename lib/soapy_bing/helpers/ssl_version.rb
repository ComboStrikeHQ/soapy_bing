require 'openssl'

module SoapyBing
  module Helpers
    module SSLVersion
      DEFAULT_SSL_VERSION = :TLSv1

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
