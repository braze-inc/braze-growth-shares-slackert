require 'slackert'

RSpec.describe Slackert::Blocks do
  describe Slackert::Blocks::Section do
    before(:each) do
      @section = Slackert::Blocks::Section.new
    end

    context 'section message too long' do
      it { expect { @section.add_section_text('A' * 5000) }.to raise_error(ArgumentError) }
    end

    context 'field message too long' do
      it { expect { @section.add_field_text('x' * 3001).to raise_error(ArgumentError) } }
    end

    context 'fields amount exceeded' do
      it { expect { @section.add_field_text('text').to raise_error(StandardError) } }
    end
  end
end
