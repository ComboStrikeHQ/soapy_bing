# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.local', '.env')
require 'soapy_bing'

desc 'Fetch Bing Ads wsdl files and store them'
task :update_wsdl_files do
  SERVICES = {
    ad_insight: 'https://adinsight.api.bingads.microsoft.com/Api/Advertiser/AdInsight/v12/AdInsightService.svc?wsdl',
    bulk: 'https://bulk.api.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v12/BulkService.svc?wsdl',
    campaign_management: 'https://campaign.api.bingads.microsoft.com/Api/Advertiser/CampaignManagement/V12/CampaignManagementService.svc?wsdl',
    customer_billing: 'https://clientcenter.api.bingads.microsoft.com/Api/Billing/v12/CustomerBillingService.svc?wsdl',
    customer_management: 'https://clientcenter.api.bingads.microsoft.com/Api/CustomerManagement/V12/CustomerManagementService.svc?wsdl',
    reporting: 'https://reporting.api.bingads.microsoft.com/Api/Advertiser/Reporting/v12/ReportingService.svc?wsdl'
  }.freeze

  SERVICES.each do |service, wsdl_url|
    File.open(SoapyBing::Service.local_wsdl_path_for(service), 'wb') do |file|
      file.write HTTParty.get(wsdl_url)
    end
  end
end
