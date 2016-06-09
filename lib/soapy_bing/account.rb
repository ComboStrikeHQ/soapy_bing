# frozen_string_literal: true
module SoapyBing
  class Account
    attr_reader :developer_token, :account_id, :customer_id

    def initialize(account_options)
      param_guard = ParamGuard.new(account_options, env_namespace: 'BING_ADS')
      @developer_token = param_guard.require!(:developer_token)
      @account_id = param_guard.require!(:account_id)
      @customer_id = param_guard.require!(:customer_id)
    end
  end
end
