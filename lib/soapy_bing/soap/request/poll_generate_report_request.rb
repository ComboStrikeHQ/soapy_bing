# frozen_string_literal: true
module SoapyBing
  module Soap
    module Request
      class PollGenerateReportRequest < Base
        class FailedStatusError < StandardError; end
        class PendingStatusError < StandardError; end
        class PollingTimeoutError < StandardError; end

        API_BASE_URL = 'https://reporting.api.bingads.microsoft.com'
        API_VERSION = 9
        API_ENDPOINT =
          "#{API_BASE_URL}/Api/Advertiser/Reporting/V#{API_VERSION}/ReportingService.svc"

        POLLING_TRIES = 100

        def perform
          Retryable.retryable(tries: POLLING_TRIES, on: PendingStatusError) { poll! }
        rescue PendingStatusError
          raise PollingTimeoutError
        end

        private

        def poll!
          response = Response::PollGenerateReportResponse.new(post(API_ENDPOINT))
          raise PendingStatusError if response.pending?
          raise FailedStatusError if response.error?
          response
        end
      end
    end
  end
end
