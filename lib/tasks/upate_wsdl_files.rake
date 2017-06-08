# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.local', '.env')
require 'soapy_bing'

desc 'Fetch Bing Ads wsdl files and store them'
task :update_wsdl_files do
  SoapyBing::Service::SERVICES.each do |service, wsdl_url|
    File.open(SoapyBing::Service.local_wsdl_path_for(service), 'wb') do |file|
      file.write HTTParty.get(wsdl_url)
    end
  end
end
