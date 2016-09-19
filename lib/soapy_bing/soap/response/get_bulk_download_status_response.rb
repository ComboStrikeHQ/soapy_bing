# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetBulkDownloadStatusResponse < Base
        StatusFailed = Class.new(StandardError)

        def extract_payload
          if response['RequestStatus'] == 'Failed'
            raise StatusFailed, response['Errors'].to_s
          end
          response.slice('PercentComplete', 'RequestStatus', 'ResultFileUrl')
        end
      end
    end
  end
end
