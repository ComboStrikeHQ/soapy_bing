# frozen_string_literal: true
RSpec.describe SoapyBing::Helpers::ClassName do
  describe '#class_name' do
    subject do
      stub_const(
        'OUTERNS::INNERNS::MyClass',
        Class.new.include(described_class)
      ).new.class_name
    end

    it 'resolves class name' do
      expect(subject).to eq 'MyClass'
    end
  end
end
