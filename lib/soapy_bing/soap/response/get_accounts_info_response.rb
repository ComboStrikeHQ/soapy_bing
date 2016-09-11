# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetAccountsInfoResponse < Base
        def extract_payload
          Array.wrap(response['AccountsInfo']['AccountInfo'])
        end
      end
    end
  end
end
