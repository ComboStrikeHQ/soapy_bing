# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetAdsByAdGroupIdResponse < Base
        def extract_payload
          Array.wrap(body['Envelope']['Body'][class_name]['Ads']['Ad'])
        end
      end
    end
  end
end
