# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class PollGenerateReportResponse < Base
        include ReportStatus

        def extract_payload
          report_status['ReportDownloadUrl']
        end
      end
    end
  end
end
