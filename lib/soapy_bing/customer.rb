# frozen_string_literal: true

module SoapyBing
  class Customer
    attr_reader :developer_token, :customer_id

    def initialize(account_options)
      param_guard = ParamGuard.new(account_options, env_namespace: 'BING_ADS')
      @developer_token = param_guard.require!(:developer_token)
      @customer_id = param_guard.require!(:customer_id)
    end
  end
end
