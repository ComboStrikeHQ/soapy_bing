# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetTargetsByCampaignIdsResponse < Base
        def extract_payload
          Array.wrap(body['Envelope']['Body'][class_name]['Targets']['Target']).first
        end
      end
    end
  end
end
