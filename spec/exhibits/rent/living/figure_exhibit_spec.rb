require 'spec_helper'

describe Rent::Living::FigureExhibit do
  load_exhibit_setup

  describe '#render_floor_input' do
    it 'renders an optional input' do
      exhibit.should_receive(:render).with(:floor, :mandatory => false)
      exhibit.render_floor_input
    end
  end
end
