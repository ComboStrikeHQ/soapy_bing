# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class GetAccountsInfoResponse < Base
        def extract_payload
          Array.wrap(body['Envelope']['Body'][class_name]['AccountsInfo']['AccountInfo'])
        end
      end
    end
  end
end
