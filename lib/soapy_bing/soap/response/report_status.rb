# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      module ReportStatus
        include Helpers::ClassName

        def status
          @status ||= extract_status
        end

        def extract_status
          report_status['Status']
        end

        def report_status
          response['ReportRequestStatus']
        end

        def error?
          status == 'Error'
        end

        def success?
          status == 'Success'
        end

        def pending?
          status == 'Pending'
        end
      end
    end
  end
end
