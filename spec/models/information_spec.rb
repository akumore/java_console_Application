require 'spec_helper'

describe Information do
  describe 'initialize with invalid attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate,
        utilization: Utilization::LIVING,
        information: Information.new(
          floors: 'drei',
          renovated_on: 'Vor 10 Jahren',
          built_on: 'Jahr 2012',
          freight_elevator_carrying_capacity: 'hundert',
          number_of_restrooms: 'zwei',
          maximal_floor_loading: '20 Kilo',
          ceiling_height: '2.6m'
        ), category: Fabricate(:category))
      @information = @real_estate.information
    end

    it 'does not pass validations' do
      expect(@information.valid?).to be_false
    end

    it 'requires a number for floors' do
      @information.should have(1).error_on(:floors)
    end

    it 'requires a number for renovated_on' do
      @information.should have(1).error_on(:renovated_on)
    end

    it 'requires a number for built_on' do
      @information.should have(1).error_on(:built_on)
    end

    it 'requires a number for freight_elevator_carrying_capacity' do
      @information.should have(1).error_on(:freight_elevator_carrying_capacity)
    end

    it 'requires a number for number_of_restrooms' do
      @information.should have(1).error_on(:number_of_restrooms)
    end

    it 'requires a number for maximal_floor_loading' do
      @information.should have(1).error_on(:maximal_floor_loading)
    end

    it 'does not require a number for ceiling_height' do
      @information.should have(0).error_on(:ceiling_height)
    end

    context 'for commercial utilization' do
      before :each do
        @real_estate = Fabricate.build(:real_estate,
          utilization: Utilization::WORKING,
          information: Information.new(
            floors: 'drei',
            renovated_on: 'Vor 10 Jahren',
            built_on: 'Jahr 2012',
            freight_elevator_carrying_capacity: 'hundert',
            number_of_restrooms: 'zwei',
            maximal_floor_loading: '20 Kilo',
            ceiling_height: '2.6m'
          ), category: Fabricate(:category))
        @information = @real_estate.information
      end

      it 'requires a number for ceiling_height' do
        @information.should have(1).error_on(:ceiling_height)
      end
    end
  end
end
