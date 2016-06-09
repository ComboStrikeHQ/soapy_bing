# frozen_string_literal: true
RSpec.describe SoapyBing::ParamGuard do
  describe '#require!' do
    let(:param_guard) { described_class.new(options, env_namespace: 'MY') }
    subject { param_guard.require!(:foo) }

    context 'when option is empty' do
      let(:options) { {} }

      context 'and environment variable is empty too' do
        it 'thows exception' do
          expect { subject }.to raise_exception SoapyBing::ParamGuard::ParamRequiredError,
            'foo have to be passed explicitly or via ENV[\'MY_FOO\']'
        end
      end

      context 'but environment variable is present' do
        before { allow(ENV).to receive(:[]).with('MY_FOO').and_return('bar_env') }

        it 'returns environment variable value' do
          expect(subject).to eq 'bar_env'
        end
      end
    end

    context 'when option is present' do
      let(:options) { { foo: 'bar' } }

      context 'and environment variable is present too' do
        before { allow(ENV).to receive(:[]).with('MY_FOO').and_return('bar_env') }

        it 'returns option value' do
          expect(subject).to eq 'bar'
        end
      end

      context 'but environment variable is empty' do
        it 'returns option value' do
          expect(subject).to eq 'bar'
        end
      end
    end
  end
end
