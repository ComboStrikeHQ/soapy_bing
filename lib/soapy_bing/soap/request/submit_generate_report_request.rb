# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class SubmitGenerateReportRequest < Base
        API_BASE_URL = 'https://reporting.api.bingads.microsoft.com'
        API_VERSION = 9
        API_ENDPOINT =
          "#{API_BASE_URL}/Api/Advertiser/Reporting/V#{API_VERSION}/ReportingService.svc"

        def perform
          Response::SubmitGenerateReportResponse.new(post(API_ENDPOINT))
        end
      end
    end
  end
end
