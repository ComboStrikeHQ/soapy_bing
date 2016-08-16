# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class GetAccountsInfoRequest < Base
        API_BASE_URL = 'https://clientcenter.api.bingads.microsoft.com'
        API_VERSION = 9
        API_ENDPOINT = "#{API_BASE_URL}/Api/CustomerManagement/" \
          "v#{API_VERSION}/CustomerManagementService.svc"

        def perform
          Response::GetAccountsInfoResponse.new(post(API_ENDPOINT))
        end
      end
    end
  end
end
