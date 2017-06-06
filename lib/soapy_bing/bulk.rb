# frozen_string_literal: true
require 'soapy_bing/bulk/campaigns'

module SoapyBing
  class Bulk
    attr_reader :service

    def initialize(*args)
      @service = Service.bulk(*args)
    end

    def campaigns(entities = nil, polling_settings = {})
      Campaigns.new(
        service: service,
        entities: entities,
        polling_settings: polling_settings
      ).rows
    end
  end
end
