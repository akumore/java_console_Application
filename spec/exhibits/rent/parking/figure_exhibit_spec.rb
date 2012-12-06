require 'spec_helper'

describe Rent::Parking::FigureExhibit do
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
    it 'renders nothing' do
      exhibit.render_floor_input.should be_nil
    end
  end
end
