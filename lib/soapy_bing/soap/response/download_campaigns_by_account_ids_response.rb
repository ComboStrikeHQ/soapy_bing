# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class DownloadCampaignsByAccountIdsResponse < Base
        def extract_payload
          response['DownloadRequestId']
        end
      end
    end
  end
end
