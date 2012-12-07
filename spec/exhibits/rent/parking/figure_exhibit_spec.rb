require 'spec_helper'

describe Rent::Parking::FigureExhibit do
  load_exhibit_setup

  describe '#render_floor_input' do
    it 'renders nothing' do
      exhibit.render_floor_input.should be_nil
    end
  end
end
