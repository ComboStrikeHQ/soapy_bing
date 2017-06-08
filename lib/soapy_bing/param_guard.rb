# frozen_string_literal: true

module SoapyBing
  class ParamGuard
    class ParamRequiredError < StandardError; end

    def initialize(local_options, env_namespace: '')
      @local_options = local_options
      @env_namespace = env_namespace
    end

    def require!(name)
      local_options.fetch(name, ENV[env_var_name(name)]) || raise(ParamRequiredError, err_msg(name))
    end

    private

    attr_reader :local_options, :env_namespace

    def err_msg(name)
      "#{name} have to be passed explicitly or via ENV['#{env_var_name(name)}']"
    end

    def env_var_name(name)
      (env_namespace.empty? ? name : "#{env_namespace}_#{name}").upcase.tr('-', '_')
    end
  end
end
