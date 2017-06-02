# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soapy_bing/version'

Gem::Specification.new do |spec|
  spec.name          = 'soapy_bing'
  spec.version       = SoapyBing::VERSION
  spec.authors       = ['ad2games GmbH']
  spec.email         = ['developers@ad2games.com']
  spec.summary       = 'Simple client for the Bing Ads APIs'
  spec.description   = "#{spec.summary} (https://developers.bingads.microsoft.com)"
  spec.homepage      = 'http://ad2games.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'erubis' # TODO: Remove when savon migration is complete
  spec.add_dependency 'activesupport'
  spec.add_dependency 'httparty'
  spec.add_dependency 'retryable', '>= 2.0.0'
  spec.add_dependency 'rubyzip', '>= 1.0.0'
  spec.add_dependency 'savon', '~> 2.11'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'dotenv'
end
