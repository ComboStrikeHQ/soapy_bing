# frozen_string_literal: true

module SoapyBing
  class Accounts
    attr_reader :service

    def initialize(*args)
      @service = Service.customer_management(*args)
    end

    def list
      response = service.get_accounts_info
      response[:accounts_info][:account_info].map do |account_info|
        build_account(account_info)
      end
    end

    private

    def build_account(account_info)
      Account.new(
        developer_token: service.customer.developer_token,
        customer_id: service.customer.customer_id,
        account_id: account_info[:id]
      )
    end
  end
end
