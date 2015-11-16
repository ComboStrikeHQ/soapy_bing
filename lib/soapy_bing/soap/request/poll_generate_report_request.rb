module SoapyBing
  module Soap
    module Request
      class PollGenerateReportRequest < Base
        class FailedStatusError < StandardError; end
        class PendingStatusError < StandardError; end
        class PollingTimeoutError < StandardError; end

        API_BASE_URL = 'https://reporting.api.bingads.microsoft.com'.freeze
        API_VERSION = 9
        API_ENDPOINT =
          "#{API_BASE_URL}/Api/Advertiser/Reporting/V#{API_VERSION}/ReportingService.svc".freeze

        POLLING_TRIES = 40

        def perform
          Retryable.retryable(tries: POLLING_TRIES, on: PendingStatusError) { poll! }
        rescue PendingStatusError
          raise PollingTimeoutError
        end

        private

        def poll!
          response = Response::PollGenerateReportResponse.new(post(API_ENDPOINT))
          fail PendingStatusError if response.pending?
          fail FailedStatusError if response.error?
          response
        end
      end
    end
  end
end
