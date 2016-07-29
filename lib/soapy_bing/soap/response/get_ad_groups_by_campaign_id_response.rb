# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetAdGroupsByCampaignIdResponse < Base
        def extract_payload
          Array.wrap(body['Envelope']['Body'][class_name]['AdGroups']['AdGroup'])
        end
      end
    end
  end
end
