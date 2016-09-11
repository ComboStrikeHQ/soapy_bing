# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      module Payload
        Fault = Class.new(StandardError)

        def payload
          @payload ||= check_errors_and_extract_payload
        end

        def check_errors_and_extract_payload
          fault = body.dig('Envelope', 'Body', 'Fault')
          raise Fault, fault.to_s if fault
          extract_payload
        end

        def extract_payload
          raise NotImplementedError
        end

        def response
          @response ||= body.dig('Envelope', 'Body', class_name)
        end
      end
    end
  end
end
