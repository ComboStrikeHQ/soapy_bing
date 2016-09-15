# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class GetBulkDownloadStatusRequest < Base
        API_BASE_URL = 'https://bulk.api.bingads.microsoft.com'
        API_VERSION = 10
        API_ENDPOINT =
          "#{API_BASE_URL}/Api/Advertiser/CampaignManagement/V#{API_VERSION}/BulkService.svc"

        def perform
          Response::GetBulkDownloadStatusResponse.new(post(API_ENDPOINT))
        end
      end
    end
  end
end
