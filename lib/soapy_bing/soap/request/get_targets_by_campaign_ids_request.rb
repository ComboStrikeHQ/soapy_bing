# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class GetTargetsByCampaignIdsRequest < Base
        API_BASE_URL = 'https://campaign.api.bingads.microsoft.com'
        API_VERSION = 10
        API_ENDPOINT = "#{API_BASE_URL}/Api/Advertiser/CampaignManagement/" \
          "V#{API_VERSION}/CampaignManagementService.svc"

        def perform
          Response::GetTargetsByCampaignIdsResponse.new(post(API_ENDPOINT))
        end
      end
    end
  end
end
