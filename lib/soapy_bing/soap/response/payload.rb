module SoapyBing
  module Soap
    module Response
      module Payload
        def payload
          @payload ||= extract_payload
        end

        def extract_payload
          fail NotImplementedError
        end
      end
    end
  end
end
