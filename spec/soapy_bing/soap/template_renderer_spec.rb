RSpec.describe SoapyBing::Soap::TemplateRenderer do
  describe '::TEMPLATE_PATH' do
    let(:files) { Dir.glob(File.join(described_class::TEMPLATE_PATH, '*.erb.xml')) }

    it 'points to folder with *.erb.xml files' do
      expect(files.size).to be > 1
    end
  end

  describe '#render' do
    let(:renderer) { described_class.new(greeting: 'Hello', target: 'World', provocation: '< &') }

    before do
      stub_const(
        "#{described_class}::TEMPLATE_PATH",
        File.join('spec', 'fixtures', 'soap_templates')
      )
    end

    it 'returns text with interpolated variables' do
      expect(renderer.render(:simple)).to eq "Hello, World!\n&lt; &amp;\n"
    end
  end
end
