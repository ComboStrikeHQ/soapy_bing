# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      module Payload
        def payload
          @payload ||= extract_payload
        end

        def extract_payload
          raise NotImplementedError
        end
      end
    end
  end
end
