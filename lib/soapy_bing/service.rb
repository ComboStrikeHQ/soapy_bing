# frozen_string_literal: true

require 'savon'

module SoapyBing
  class Service
    DEFAULT_GLOBALS = {
      element_form_default: :qualified,
      convert_request_keys_to: :camelcase
    }.freeze

    class << self
      # Prefer to define methods for each service explicitly
      # rubocop:disable all
      def ad_insight         (options = {}); build(:ad_insight,          options); end
      def bulk               (options = {}); build(:bulk,                options); end
      def campaign_management(options = {}); build(:campaign_management, options); end
      def customer_billing   (options = {}); build(:customer_billing,    options); end
      def customer_management(options = {}); build(:customer_management, options); end
      def reporting          (options = {}); build(:reporting,           options); end
      # rubocop:enable all

      def build(bing_ads_service, options)
        options[:savon_globals] ||= {}
        options[:savon_globals][:wsdl] = local_wsdl_path_for(bing_ads_service)
        options[:savon_globals] = DEFAULT_GLOBALS.merge(options[:savon_globals])
        new(options)
      end

      def local_wsdl_path_for(service)
        File.join('lib', 'soapy_bing', 'wsdl', "#{service}.wsdl")
      end
    end

    attr_reader :oauth_credentials, :customer, :account, :savon_client

    def initialize(oauth_credentials: {}, customer: {}, account: {}, savon_globals: {}, &block)
      @oauth_credentials = SoapyBing::OauthCredentials.new(oauth_credentials)
      @customer = SoapyBing::Customer.new(customer)
      @account = SoapyBing::Account.new(account) if account_id?(account)
      @savon_client = Savon::Client.new(savon_globals, &block)
    end

    def method_missing(method, *args, &block)
      operation?(method) ? call(method, args.first, &block) : super
    end

    def respond_to_missing?(method, *_)
      operation?(method) || super
    end

    private

    def operation?(method)
      savon_client.operations.include?(method)
    end

    def account_id?(account)
      account.fetch(:account_id, ENV['BING_ADS_ACCOUNT_ID'])
    end

    def call(operation_name, message, &block)
      ServiceOperation.new(self, operation_name).call(message, &block)
    end
  end
end
