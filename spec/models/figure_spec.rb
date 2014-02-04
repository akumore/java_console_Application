# encoding: utf-8
require 'spec_helper'

describe Figure do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :figure => Figure.new, :category => Fabricate(:category))
      @figure = @real_estate.figure
    end

    it 'does not pass validations' do
      @figure.should_not be_valid
    end

    context 'for living utilization' do
      before :each do
        @real_estate.utilization = Utilization::LIVING
      end

      it 'requires a floor' do
        @figure.should have(2).error_on(:floor)
      end

      it 'requires rooms' do
        @figure.should have(2).error_on(:rooms)
      end
    end

    context 'for working utilization' do
      before :each do
        @real_estate.utilization = Utilization::WORKING
      end

      it 'requires a floor' do
        @figure.should have(2).error_on(:floor)
      end

      it 'requires a usable surface' do
        @figure.should have(2).error_on(:usable_surface)
      end
    end
  end

  describe 'initialize with invalid attributes' do
    context 'for private utilization' do
      before :each do
        @real_estate = Fabricate.build(:real_estate,
          :utilization => Utilization::LIVING,
          :figure => Figure.new(
            :rooms => '2-3.5',
            :floor => 'EG',
            :living_surface => '120qm2',
            :property_surface => '19qm2',
            :usable_surface => '300qm2',
            :storage_surface => '20qm2',
            :inside_parking_spots => 'eins',
            :outside_parking_spots => 'zwei',
            :covered_slot => 'drei',
            :covered_bike => 'vier',
            :outdoor_bike => 'fünf',
            :single_garage => 'sechs',
            :double_garage => 'sieben'
          ), :category => Fabricate(:category))
        @figure = @real_estate.figure
      end

      it 'does not pass validations' do
        @figure.should_not be_valid
      end

      it 'requires rooms to be present' do
        @figure.update_attribute(:rooms, '')
        @figure.should have(2).error_on(:rooms)
      end

      it 'requires a number of rooms' do
        @figure.should have(1).error_on(:rooms)
      end

      it 'requires a number for floor' do
        @figure.should have(1).error_on(:floor)
      end

      it 'requires a number for living_surface' do
        @figure.should have(1).error_on(:living_surface)
      end

      it 'requires a number for property_surface' do
        @figure.should have(1).error_on(:property_surface)
      end

      it 'requires a number for the inside_parking_spots' do
        @figure.should have(1).error_on(:inside_parking_spots)
      end

      it 'requires a number for the outside_parking_spots' do
        @figure.should have(1).error_on(:outside_parking_spots)
      end

      it 'requires a number for the covered_slot' do
        @figure.should have(1).error_on(:covered_slot)
      end

      it 'requires a number for the covered_bike' do
        @figure.should have(1).error_on(:covered_bike)
      end

      it 'requires a number for the outdoor_bike' do
        @figure.should have(1).error_on(:outdoor_bike)
      end

      it 'requires a number for the single_garage' do
        @figure.should have(1).error_on(:single_garage)
      end

      it 'requires a number for the double_garage' do
        @figure.should have(1).error_on(:double_garage)
      end
    end

    context 'for commercial utilization' do
      before :each do
        @real_estate = Fabricate.build(:real_estate,
          :utilization => Utilization::WORKING,
          :figure => Figure.new(
            :rooms => '2-3.5',
            :floor => 'EG',
            :living_surface => '120qm2',
            :property_surface => '19qm2',
            :usable_surface => '300qm2',
            :storage_surface => '20qm2'
          ), :category => Fabricate(:category))
        @figure = @real_estate.figure
      end

      it 'requires a number for storage_surface' do
        @figure.should have(1).error_on(:storage_surface)
      end

      it 'requires a floor to be present' do
        @figure.update_attribute(:floor, '')
        @figure.should have(2).error_on(:floor)
      end

      it 'requires a positive or negative floor number' do
        @figure.should have(1).error_on(:floor)
      end

      it 'requires usable_surface to be present' do
        @figure.update_attribute(:usable_surface, '')
        @figure.should have(2).error_on(:usable_surface)
      end

      it 'requires a number for usable_surface' do
        @figure.should have(1).error_on(:usable_surface)
      end
    end
  end

  describe '#has_roofed_parking_spot' do
    before :each do
      @real_estate = Fabricate.build(:real_estate,
        :utilization => Utilization::LIVING,
        :figure => Fabricate.build(:figure,
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        ),
        :category => Fabricate(:category))
      @figure = @real_estate.figure
    end

    it 'aliases #has_roofed_parking_spot?' do
      @figure.should respond_to(:has_roofed_parking_spot?)
      @figure.has_garage.should == @figure.has_roofed_parking_spot?
    end

    context 'without any parking spots' do
      it 'returns false' do
        @figure.has_roofed_parking_spot.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns true' do
        @figure.inside_parking_spots = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with outside parking spots' do
      it 'returns false' do
        @figure.outside_parking_spots = 1
        @figure.has_roofed_parking_spot.should be_false
      end
    end

    context 'with covered slots' do
      it 'returns true' do
        @figure.covered_slot = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with covered bike slots' do
      it 'returns true' do
        @figure.covered_bike = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with outdoor bike slots' do
      it 'returns true' do
        @figure.outdoor_bike = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with a single garage' do
      it 'returns true' do
        @figure.single_garage = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with a double garage' do
      it 'returns true' do
        @figure.double_garage = 1
        @figure.has_roofed_parking_spot.should be_true
      end
    end
  end

  describe '#has_garage' do
    before :each do
      @real_estate = Fabricate.build(:real_estate,
        :utilization => Utilization::LIVING,
        :figure => Fabricate.build(:figure,
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        ),
        :category => Fabricate(:category))
      @figure = @real_estate.figure
    end

    it 'aliases #has_garage?' do
      @figure.should respond_to(:has_garage?)
      @figure.has_garage.should == @figure.has_garage?
    end

    context 'without any parking spots' do
      it 'returns false' do
        @figure.has_garage.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns true' do
        @figure.inside_parking_spots = 1
        @figure.has_garage.should be_true
      end
    end

    context 'with outside parking spots' do
      it 'returns false' do
        @figure.outside_parking_spots = 1
        @figure.has_garage.should be_false
      end
    end

    context 'with covered slots' do
      it 'returns false' do
        @figure.covered_slot = 1
        @figure.has_garage.should be_false
      end
    end

    context 'with covered bike slots' do
      it 'returns true' do
        @figure.covered_bike = 1
        @figure.has_garage.should be_true
      end
    end

    context 'with outdoor bike slots' do
      it 'returns false' do
        @figure.outdoor_bike = 1
        @figure.has_garage.should be_false
      end
    end

    context 'with a single garage' do
      it 'returns true' do
        @figure.single_garage = 1
        @figure.has_garage.should be_true
      end
    end

    context 'with a double garage' do
      it 'returns true' do
        @figure.double_garage = 1
        @figure.has_garage.should be_true
      end
    end
  end

  describe '#has_parking_spot' do
    before :each do
      @real_estate = Fabricate.build(:real_estate,
        :utilization => Utilization::LIVING,
        :figure => Fabricate.build(:figure,
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        ),
        :category => Fabricate(:category))
      @figure = @real_estate.figure
    end

    it 'aliases #has_parking_spot?' do
      @figure.should respond_to(:has_parking_spot?)
      @figure.has_parking_spot.should == @figure.has_parking_spot?
    end

    context 'without any parking spots' do
      it 'returns false' do
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns false' do
        @figure.inside_parking_spots = 1
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with outside parking spots' do
      it 'returns true' do
        @figure.outside_parking_spots = 1
        @figure.has_parking_spot.should be_true
      end
    end

    context 'with covered slots' do
      it 'returns false' do
        @figure.covered_slot = 1
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with covered bike slots' do
      it 'returns false' do
        @figure.covered_bike = 1
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with outdoor bike slots' do
      it 'returns false' do
        @figure.outdoor_bike = 1
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with a single garage' do
      it 'returns false' do
        @figure.single_garage = 1
        @figure.has_parking_spot.should be_false
      end
    end

    context 'with a double garage' do
      it 'returns false' do
        @figure.double_garage = 1
        @figure.has_parking_spot.should be_false
      end
    end
  end
end
