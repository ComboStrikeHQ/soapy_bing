require 'httparty'

module SoapyBing
  module Soap
    module Request
      class Base
        include Helpers::ClassName

        DEFAULT_HTTP_HEADERS = {
          'Content-Type' => 'text/xml;charset=UTF-8'
        }.freeze

        attr_reader :context

        def initialize(context:)
          @context = context
        end

        def post(url, body: default_body, headers: default_headers)
          HTTParty.post(url, body: body, headers: headers)
        end

        def default_body
          TemplateRenderer.new(context).render(action_name.underscore)
        end

        def default_headers
          DEFAULT_HTTP_HEADERS.merge('SOAPAction' => action_name)
        end

        def action_name
          class_name.sub(/Request$/, '')
        end
      end
    end
  end
end
