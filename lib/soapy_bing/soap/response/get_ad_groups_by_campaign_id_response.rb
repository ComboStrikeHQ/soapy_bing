# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetAdGroupsByCampaignIdResponse < Base
        def extract_payload
          Array.wrap(response['AdGroups']['AdGroup'])
        end
      end
    end
  end
end
