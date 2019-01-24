# frozen_string_literal: true

if ENV['CI'] || ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.root(File.expand_path('../..', __FILE__))
  SimpleCov.start do
    minimum_coverage 99.71
    add_filter '/spec/'
  end
end
