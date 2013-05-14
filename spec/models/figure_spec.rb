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
        @real_estate.utilization = RealEstate::UTILIZATION_PRIVATE
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
        @real_estate.utilization = RealEstate::UTILIZATION_COMMERICAL
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
            :ceiling_height => '2.6m',
            :floors => 'drei',
            :renovated_on => 'Vor 10 Jahren',
            :built_on => 'Jahr 2012'
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
        @figure.should have(2).error_on(:floor)
      end

      it 'requires a number for living_surface' do
        @figure.should have(1).error_on(:living_surface)
      end

      it 'requires a number for property_surface' do
        @figure.should have(1).error_on(:property_surface)
      end

      it 'requires a number for floors' do
        @figure.should have(1).error_on(:floors)
      end

      it 'requires a number for renovated_on' do
        @figure.should have(1).error_on(:renovated_on)
      end

      it 'requires a number for built_on' do
        @figure.should have(1).error_on(:built_on)
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
            :storage_surface => '20qm2',
            :ceiling_height => '2.6m',
            :floors => 'drei',
            :renovated_on => 'Vor 10 Jahren',
            :built_on => 'Jahr 2012'
          ), :category => Fabricate(:category))
        @figure = @real_estate.figure
      end

      it 'requires a number for ceiling_height' do
        @figure.should have(1).error_on(:ceiling_height)
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
end
