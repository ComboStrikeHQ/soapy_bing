require 'cgi'
require 'vcr'
require 'active_support/core_ext/hash/conversions'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: %i(method uri body) }

  c.filter_sensitive_data('bing-ads-oauth-client-id') { ENV['BING_ADS_OAUTH_CLIENT_ID'] }
  c.filter_sensitive_data('bing-ads-oauth-client-secret') { ENV['BING_ADS_OAUTH_CLIENT_SECRET'] }
  c.filter_sensitive_data('bing-ads-oauth-refresh-token') do
    CGI.escape(ENV['BING_ADS_OAUTH_REFRESH_TOKEN'])
  end
  c.filter_sensitive_data('bing-ads-oauth-refresh-token') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'application/json'
      JSON.parse(interaction.response.body)['refresh_token']
    end
  end
  c.filter_sensitive_data('bing-ads-oauth-authentication-token') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'application/json'
      JSON.parse(interaction.response.body)['access_token']
    end
  end
  c.filter_sensitive_data('bing-ads-oauth-user-id') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'application/json'
      JSON.parse(interaction.response.body)['user_id']
    end
  end
  c.filter_sensitive_data('bing-ads-developer-token') { ENV['BING_ADS_DEVELOPER_TOKEN'] }
  c.filter_sensitive_data('bing-ads-account-id') { ENV['BING_ADS_ACCOUNT_ID'] }
  c.filter_sensitive_data('bing-ads-customer-id') { ENV['BING_ADS_CUSTOMER_ID'] }

  c.filter_sensitive_data('bing-ads-report-tracking-id') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'text/xml; charset=utf-8'
      Hash.from_xml(interaction.response.body)['Envelope']['Header']['TrackingId']
    end
  end
  c.filter_sensitive_data('bing-ads-report-request-id') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'text/xml; charset=utf-8'
      body = Hash.from_xml(interaction.response.body)['Envelope']['Body']
      if body['SubmitGenerateReportResponse']
        body['SubmitGenerateReportResponse']['ReportRequestId']
      end
    end
  end
  c.filter_sensitive_data('bing-ads-report-request-id') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'text/xml; charset=utf-8'
      body = Hash.from_xml(interaction.request.body)['Envelope']['Body']
      if body['PollGenerateReportRequest']
        body['PollGenerateReportRequest']['ReportRequestId']
      end
    end
  end
  c.filter_sensitive_data('bing-ads-oauth-authentication-token') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'text/xml; charset=utf-8'
      Hash.from_xml(interaction.request.body)['Envelope']['Header']['AuthenticationToken']
    end
  end
  c.filter_sensitive_data('bing-ads-report-download-id') do |interaction|
    if interaction.request.uri =~ %r{https://(.*)\?q=(.*)}
      Regexp.last_match(2)
    end
  end
  c.filter_sensitive_data('bing-ads-report-download-id') do |interaction|
    if interaction.response.headers['Content-Type'].first == 'text/xml; charset=utf-8'
      response = Hash.from_xml(interaction.response.body)
      report = response['Envelope']['Body']['PollGenerateReportResponse']
      if report && report ['ReportRequestStatus']
        if report['ReportRequestStatus']['ReportDownloadUrl'] =~ %r{https://(.*)\?q=(.*)}
          Regexp.last_match(2)
        end
      end
    end
  end

  c.before_record do |interaction|
    # auto-generate report payload fixtures
    # spec/fixtures/reports/campaign_performance_report.json
    # spec/fixtures/reports/campaing_performance_report.csv
    if interaction.response.headers['Content-Type'].first == 'application/x-zip-compressed'
      # refactor zip into module
      csv_data = Zip::InputStream.open(StringIO.new(interaction.response.body)) do |archive_io|
        file_io = archive_io.get_next_entry.get_input_stream
        file_io.read
      end

      fixtures_dir = File.join('spec', 'fixtures', 'reports')
      File.open(File.join(fixtures_dir, 'campaign_performance_report.json'), 'wb') do |file|
        parser = SoapyBing::Ads::Reports::Parsers::CSVParser.new(csv_data)
        file.write(JSON.pretty_generate(parser.rows))
      end
      File.open(File.join(fixtures_dir, 'campaign_performance_report.csv'), 'wb') do |file|
        file.write(csv_data)
      end
    end
  end

  c.ignore_hosts 'codeclimate.com' # allow codeclimate-test-reporter to phone home
end
