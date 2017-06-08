# frozen_string_literal: true
require 'savon'

module SoapyBing
  class Service
    DEFAULT_GLOBALS = {
      element_form_default: :qualified,
      convert_request_keys_to: :camelcase
    }.freeze

    SERVICES = {
      ad_insight: 'https://adinsight.api.bingads.microsoft.com/Api/Advertiser/AdInsight/v11/AdInsightService.svc?wsdl',
      bulk: 'https://bulk.api.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v11/BulkService.svc?wsdl',
      campaign_management: 'https://campaign.api.bingads.microsoft.com/Api/Advertiser/CampaignManagement/V11/CampaignManagementService.svc?wsdl',
      customer_billing: 'https://clientcenter.api.bingads.microsoft.com/Api/Billing/v11/CustomerBillingService.svc?wsdl',
      customer_management: 'https://clientcenter.api.bingads.microsoft.com/Api/CustomerManagement/V11/CustomerManagementService.svc?wsdl',
      reporting: 'https://reporting.api.bingads.microsoft.com/Api/Advertiser/Reporting/v11/ReportingService.svc?wsdl'
    }.freeze

    class << self
      SERVICES.each_key do |service|
        define_method(service) do |options = {}|
          options[:savon_globals] ||= {}
          options[:savon_globals][:wsdl] = local_wsdl_path_for(service)
          options[:savon_globals] = DEFAULT_GLOBALS.merge(options[:savon_globals])
          new(options)
        end
      end

      def local_wsdl_path_for(service)
        File.join('lib', 'soapy_bing', 'wsdl', "#{service}.wsdl")
      end
    end

    attr_reader :oauth_credentials, :customer, :account, :savon_client

    def initialize(oauth_credentials: {}, customer: {}, account: {}, savon_globals: {}, &block)
      @oauth_credentials = SoapyBing::OauthCredentials.new(oauth_credentials)
      @customer = SoapyBing::Customer.new(customer)
      @account = SoapyBing::Account.new(account)
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

    def call(operation_name, message, &block)
      ServiceOperation.new(self, operation_name).call(message, &block)
    end
  end
end
