# encoding: utf-8
require 'spec_helper'

describe Infrastructure do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :infrastructure => Infrastructure.new(
          :inside_parking_spots => 'eins',
          :outside_parking_spots => 'zwei',
          :covered_slot => 'drei',
          :covered_bike => 'vier',
          :outdoor_bike => 'fünf',
          :single_garage => 'sechs',
          :double_garage => 'sieben'
        ), :category => Fabricate(:category))
      @infrastructure = @real_estate.infrastructure
    end

    it 'does not pass validations' do
      @infrastructure.should_not be_valid
    end

    it 'requires a number for the inside_parking_spots' do
      @infrastructure.should have(1).error_on(:inside_parking_spots)
    end

    it 'requires a number for the outside_parking_spots' do
      @infrastructure.should have(1).error_on(:outside_parking_spots)
    end

    it 'requires a number for the covered_slot' do
      @infrastructure.should have(1).error_on(:covered_slot)
    end

    it 'requires a number for the covered_bike' do
      @infrastructure.should have(1).error_on(:covered_bike)
    end

    it 'requires a number for the outdoor_bike' do
      @infrastructure.should have(1).error_on(:outdoor_bike)
    end

    it 'requires a number for the single_garage' do
      @infrastructure.should have(1).error_on(:single_garage)
    end

    it 'requires a number for the double_garage' do
      @infrastructure.should have(1).error_on(:double_garage)
    end

    it 'has 4 errors' do
      @infrastructure.valid?
      @infrastructure.errors.should have(7).items
    end
  end

  describe '#has_roofed_parking_spot' do
    it 'aliases #has_roofed_parking_spot?' do
      infrastructure = Infrastructure.new
      infrastructure.should respond_to(:has_roofed_parking_spot?)
      infrastructure.has_garage.should == infrastructure.has_roofed_parking_spot?
    end

    context 'without any parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with outside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 1,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_false
      end
    end

    context 'with covered slots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 1,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with covered bike slots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 1,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with outdoor bike slots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 1,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with a single garage' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 1,
          :double_garage => 0
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end

    context 'with a double garage' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 1
        )
        infrastructure.has_roofed_parking_spot.should be_true
      end
    end
  end

  describe '#has_garage' do
    it 'aliases #has_garage?' do
      infrastructure = Infrastructure.new
      infrastructure.should respond_to(:has_garage?)
      infrastructure.has_garage.should == infrastructure.has_garage?
    end

    context 'without any parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_true
      end
    end

    context 'with outside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 1,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'with covered slots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 1,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'with covered bike slots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 1,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_true
      end
    end

    context 'with outdoor bike slots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 1,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'with a single garage' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 1,
          :double_garage => 0
        )
        infrastructure.has_garage.should be_true
      end
    end

    context 'with a double garage' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 1
        )
        infrastructure.has_garage.should be_true
      end
    end
  end

  describe '#has_parking_spot' do
    it 'aliases #has_parking_spot?' do
      infrastructure = Infrastructure.new
      infrastructure.should respond_to(:has_parking_spot?)
      infrastructure.has_parking_spot.should == infrastructure.has_parking_spot?
    end

    context 'without any parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with outside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 1,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_true
      end
    end

    context 'with covered slots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 1,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with covered bike slots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 1,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with outdoor bike slots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 1,
          :single_garage => 0,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with a single garage' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 1,
          :double_garage => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with a double garage' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :outside_parking_spots => 0,
          :covered_slot => 0,
          :covered_bike => 0,
          :outdoor_bike => 0,
          :single_garage => 0,
          :double_garage => 1
        )
        infrastructure.has_parking_spot.should be_false
      end
    end
  end
end
