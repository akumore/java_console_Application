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
end
