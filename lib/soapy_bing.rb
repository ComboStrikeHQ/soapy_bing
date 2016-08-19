# frozen_string_literal: true
require 'httparty'
require 'retryable'
require 'active_support'
require 'active_support/core_ext/string/inflections'

require 'soapy_bing/helpers'
require 'soapy_bing/param_guard'
require 'soapy_bing/customer'
require 'soapy_bing/account'
require 'soapy_bing/oauth_credentials'
require 'soapy_bing/soap'
require 'soapy_bing/ads'
require 'soapy_bing/accounts'
