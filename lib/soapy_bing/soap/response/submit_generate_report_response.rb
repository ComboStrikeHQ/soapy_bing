# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class SubmitGenerateReportResponse < Base
        def extract_payload
          response['ReportRequestId']
        end
      end
    end
  end
end
