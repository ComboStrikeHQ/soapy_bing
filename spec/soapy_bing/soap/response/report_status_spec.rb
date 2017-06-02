# frozen_string_literal: true
RSpec.describe SoapyBing::Soap::Response::ReportStatus do
  before do
    stub_const(
      'MyCustomResponse',
      Class
        .new(SoapyBing::Soap::Response::Base)
        .include(described_class)
    )
  end
  let(:response_hash) do
    {
      'Envelope' => {
        'Body' => {
          'MyCustomResponse' => {
            'ReportRequestStatus' => {
              'Status' => nil
            }
          }
        }
      }
    }
  end
  subject(:response) { MyCustomResponse.new(response_hash) }

  describe 'status' do
    before do
      response_hash['Envelope']['Body']['MyCustomResponse']['ReportRequestStatus']
        .merge!('Status' => status)
    end

    context 'when error' do
      let(:status) { 'Error' }

      it '#status is Error' do
        expect(response.status).to eq status
      end

      it '#error? is false' do
        expect(response).to be_error
      end

      it '#success? is false' do
        expect(response).not_to be_success
      end

      it '#pending? is false' do
        expect(response).not_to be_pending
      end
    end

    context 'when success' do
      let(:status) { 'Success' }

      it '#status is Success' do
        expect(response.status).to eq status
      end

      it '#error? is false' do
        expect(response).not_to be_error
      end

      it '#success? is true' do
        expect(response).to be_success
      end

      it '#pending? is false' do
        expect(response).not_to be_pending
      end
    end

    context 'when pending' do
      let(:status) { 'Pending' }

      it '#status is Pending' do
        expect(response.status).to eq status
      end

      it '#error? is false' do
        expect(response).not_to be_error
      end

      it '#success? is false' do
        expect(response).not_to be_success
      end

      it '#pending? is true' do
        expect(response).to be_pending
      end
    end
  end
end