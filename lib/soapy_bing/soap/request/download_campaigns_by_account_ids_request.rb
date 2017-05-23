# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class DownloadCampaignsByAccountIdsRequest < Base
        API_BASE_URL = 'https://bulk.api.bingads.microsoft.com'
        API_VERSION = 11
        API_ENDPOINT =
          "#{API_BASE_URL}/Api/Advertiser/CampaignManagement/v#{API_VERSION}/BulkService.svc"

        def perform
          Response::DownloadCampaignsByAccountIdsResponse.new(post(API_ENDPOINT))
        end
      end
    end
  end
end
