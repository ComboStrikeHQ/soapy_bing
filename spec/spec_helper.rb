# frozen_string_literal: true

ENV['BING_ADS_SANDBOX'] = '1'
require 'simplecov_setup'

require 'bundler/setup'
Bundler.require(:default, :development)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!
  config.expose_dsl_globally = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed
end

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'soapy_bing'
