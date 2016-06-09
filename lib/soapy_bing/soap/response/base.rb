# frozen_string_literal: true
module SoapyBing
  module Soap
    module Response
      class Base
        include Helpers::ClassName
        include Payload

        attr_reader :body

        def initialize(body)
          @body = body
        end
      end
    end
  end
end
