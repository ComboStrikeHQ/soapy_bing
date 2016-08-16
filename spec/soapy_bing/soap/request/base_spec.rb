# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Request::Base do
  let(:req_context) { { foo: 'Bar' } }
  subject(:request) { described_class.new(context: req_context) }

  before { stub_const('MyCustomRequest', Class.new(described_class) {}) }
  let(:my_custom_request) { MyCustomRequest.new(context: req_context) }

  describe '#context' do
    it 'keeps initialized value' do
      expect(request.context).to eq req_context
    end
  end

  describe '#post' do
    let(:body) { 'my body' }
    let(:headers) { { 'My' => 'Header' } }

    it 'delegates post request to HTTParty' do
      expect(HTTParty).to receive(:post).with(
        'http://example.com',
        hash_including(body: body, headers: hash_including(headers))
      )
      request.post('http://example.com', body: body, headers: headers)
    end
  end

  describe '#default_body' do
    subject(:default_body) { my_custom_request.default_body }
    it 'renders request body template' do
      renderer = instance_double(SoapyBing::Soap::TemplateRenderer)
      expect(SoapyBing::Soap::TemplateRenderer).to receive(:new)
        .with(hash_including(req_context)).and_return(renderer)
      expect(renderer).to receive(:render).with('my_custom')
      default_body
    end
  end

  describe '#default_headers' do
    subject(:default_headers) { my_custom_request.default_headers }
    it 'contains soap action' do
      expect(default_headers).to include('SOAPAction' => 'MyCustom')
    end
    it 'contains default headers' do
      expect(default_headers).to include(described_class::DEFAULT_HTTP_HEADERS)
    end
  end

  describe '#action_name' do
    subject(:action_name) { my_custom_request.action_name }
    it 'resolves request\'s class soap action' do
      expect(action_name).to eq 'MyCustom'
    end
  end
end
