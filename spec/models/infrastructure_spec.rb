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

  describe '#has_garage' do
    it 'aliases #has_garage?' do
      infrastructure = Infrastructure.new
      infrastructure.should respond_to(:has_garage?)
      infrastructure.has_garage.should == infrastructure.has_garage?
    end

    context 'without inside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'with inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1
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

    context 'witout outside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'with outside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 1
        )
        infrastructure.has_parking_spot.should be_true
      end
    end
  end

  describe '#build_points_of_interest' do
    before do
      @real_estate = Fabricate.build(:real_estate, :utilization => Utilization::PARKING, :infrastructure => Infrastructure.new(
          :inside_parking_spots => 'eins',
          :outside_parking_spots => 'zwei'
        ), :category => Fabricate(:category))
      @infrastructure = @real_estate.infrastructure
    end

    context 'with parking utilization' do
      it "returns #{PointOfInterest::PARKING_TYPES}" do
        @infrastructure.build_points_of_interest(@real_estate).should == PointOfInterest::PARKING_TYPES
      end
    end

    context 'with every ohter utilization' do
      it "returns #{PointOfInterest::TYPES}" do
        @real_estate.update_attributes(:utilization => Utilization::LIVING)
        @infrastructure.build_points_of_interest(@real_estate).should == PointOfInterest::TYPES
      end
    end
  end
end
