# frozen_string_literal: true
RSpec.describe SoapyBing::Helpers::SSLVersion do
  describe '#ssl_version' do
    subject { stub_const('MyClass', Class.new.include(described_class)).new.ssl_version }

    context 'when DEFAULT_SSL_VERSION is available' do
      before do
        stub_const('OpenSSL::SSL::SSLContext::METHODS', [described_class::DEFAULT_SSL_VERSION])
      end

      it 'responds with DEFAULT_SSL_VERSION' do
        expect(subject).to be MyClass::DEFAULT_SSL_VERSION
      end
    end

    context 'when DEFAULT_SSL_VERSION is not available' do
      before { stub_const('OpenSSL::SSL::SSLContext::METHODS', []) }

      it 'responds with OpenSSL default version' do
        expect(subject).to be OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version]
      end
    end
  end
end
