require 'spec_helper'

describe Rent::Living::FigureExhibit do
  let :figure do
    Figure.new
  end

  let :context do
    mock(Object, :render => 'template html')
  end

  let :exhibit do
    described_class.new(figure, context)
  end

  describe '#render_floor_input' do
    it 'renders a mandatory input' do
      exhibit.should_receive(:render).with(:floor, :mandatory => false)
      exhibit.render_floor_input
    end
  end
end
