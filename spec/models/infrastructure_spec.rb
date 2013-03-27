require 'spec_helper'

describe Infrastructure do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :infrastructure => Infrastructure.new(
          :inside_parking_spots => 'eins',
          :outside_parking_spots => 'zwei',
          :inside_parking_spots_temporary => 'drei',
          :outside_parking_spots_temporary => 'vier'
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

    it 'requires a number for the inside_parking_spots_temporary' do
      @infrastructure.should have(1).error_on(:inside_parking_spots_temporary)
    end

    it 'requires a number for the outside_parking_spots_temporary' do
      @infrastructure.should have(1).error_on(:outside_parking_spots_temporary)
    end

    it 'has 4 errors' do
      @infrastructure.valid?
      @infrastructure.errors.should have(4).items
    end
  end

  describe '#has_garage' do
    it 'aliases #has_garage?' do
      infrastructure = Infrastructure.new
      infrastructure.should respond_to(:has_garage?)
      infrastructure.has_garage.should == infrastructure.has_garage?
    end

    context 'without inside parking spots and without temp inside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :inside_parking_spots_temporary => 0
        )
        infrastructure.has_garage.should be_false
      end
    end

    context 'without inside parking spots but with temp inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 0,
          :inside_parking_spots_temporary => 1
        )
        infrastructure.has_garage.should be_true
      end
    end

    context 'with inside parking spots and with temp inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1,
          :inside_parking_spots_temporary => 1
        )
        infrastructure.has_garage.should be_true
      end
    end

    context 'with inside parking spots but without temp inside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :inside_parking_spots => 1,
          :inside_parking_spots_temporary => 0
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

    context 'witout outside parking spots and without temp outside parking spots' do
      it 'returns false' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 0,
          :outside_parking_spots_temporary => 0
        )
        infrastructure.has_parking_spot.should be_false
      end
    end

    context 'without outside parking spots but with temp outside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 0,
          :outside_parking_spots_temporary => 1
        )
        infrastructure.has_parking_spot.should be_true
      end
    end

    context 'with outside parking spots and with temp outside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 1,
          :outside_parking_spots_temporary => 1
        )
        infrastructure.has_parking_spot.should be_true
      end
    end

    context 'with outside parking spots but without temp outside parking spots' do
      it 'returns true' do
        infrastructure = Infrastructure.new(
          :outside_parking_spots => 1,
          :outside_parking_spots_temporary => 0
        )
        infrastructure.has_parking_spot.should be_true
      end
    end
  end

  describe '#build_points_of_interest' do
    before do
      @real_estate = Fabricate.build(:real_estate, :utilization => Utilization::PARKING, :infrastructure => Infrastructure.new(
          :inside_parking_spots => 'eins',
          :outside_parking_spots => 'zwei',
          :inside_parking_spots_temporary => 'drei',
          :outside_parking_spots_temporary => 'vier'
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
