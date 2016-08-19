# frozen_string_literal: true
module SoapyBing
  class Accounts
    attr_reader :oauth_credentials, :customer

    def initialize(oauth: {}, customer: {})
      @oauth_credentials = OauthCredentials.new(oauth)
      @customer = Customer.new(customer)
    end

    def list
      do_request(Soap::Request::GetAccountsInfoRequest).map do |account|
        Account.new(
          developer_token: customer.developer_token,
          customer_id: customer.customer_id,
          account_id: account['Id']
        )
      end
    end

    private

    def do_request(klass, options = {})
      klass.new(context: {
        authentication_token: oauth_credentials.access_token,
        developer_token: customer.developer_token
      }.merge(options))
        .perform
        .payload
    end
  end
end
