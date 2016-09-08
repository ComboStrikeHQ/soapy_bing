# frozen_string_literal: true
require 'ostruct'
require 'erubis'

module SoapyBing
  module Soap
    class TemplateRenderer < OpenStruct
      TEMPLATE_PATH = File.expand_path('../templates', __FILE__)

      def render(template_name)
        template_body = read(template_name)
        Erubis::XmlEruby.new(template_body).result(binding)
      end

      private

      def read(name)
        File.read(File.join(TEMPLATE_PATH, "#{name}.xml.erb"))
      end
    end
  end
end
