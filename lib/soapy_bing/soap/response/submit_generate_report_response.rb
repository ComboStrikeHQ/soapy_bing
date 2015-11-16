module SoapyBing
  module Soap
    module Response
      class SubmitGenerateReportResponse < Base
        def extract_payload
          body['Envelope']['Body'][class_name]['ReportRequestId']
        end
      end
    end
  end
end
