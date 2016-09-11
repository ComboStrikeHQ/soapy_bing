# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetBulkDownloadStatusResponse < Base
        def extract_payload
          response.slice('PercentComplete', 'RequestStatus', 'ResultFileUrl')
        end
      end
    end
  end
end
