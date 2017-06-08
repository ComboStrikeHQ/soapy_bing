# frozen_string_literal: true

require 'savon'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/module/delegation'

module SoapyBing
  class ServiceOperation
    attr_reader :service, :name
    delegate :savon_client, :oauth_credentials, :customer, :account, to: :service

    def initialize(service, name)
      @service = service
      @name = name
    end

    def call(message = {})
      response = savon_client.call(
        name,
        message: block_given? ? yield(namespace_identifier) : message,
        soap_header: soap_header
      )
      response.body[output]
    end

    private

    def soap_header
      {
        action: convert_key(name),
        authentication_token: oauth_credentials.access_token,
        developer_token: customer.developer_token,
        customer_account_id: account.account_id
      }.transform_keys do |key|
        "#{namespace_identifier}:#{convert_key(key)}"
      end
    end

    def convert_key(key)
      Gyoku::XMLKey.create(key, key_converter: savon_client.globals[:convert_request_keys_to])
    end

    def namespace_identifier
      wsdl_operation.fetch(:namespace_identifier)
    end

    def output
      original_output = wsdl_operation.fetch(:output)
      convert_tag = savon_client.globals[:convert_response_tags_to]
      convert_tag.respond_to?(:call) ? convert_tag.call(original_output) : original_output
    end

    def wsdl_operation
      wsdl.operations.fetch(name)
    end

    def wsdl
      savon_client.instance_variable_get(:@wsdl)
    end
  end
end
