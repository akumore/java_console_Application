require 'spec_helper'

describe InformationDecorator do
  before { ApplicationController.new.set_current_view_context }

  before :each do
    @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :offer => RealEstate::OFFER_FOR_RENT,
        :information => Fabricate.build(:information,
          :display_estimated_available_from => 'Mai 2012',
          :has_balcony => true,
          :has_swimming_pool => true,
          :maximal_floor_loading => 140,
          :freight_elevator_carrying_capacity => 150,
        )
      )

      @information = InformationDecorator.new(@real_estate.information)
  end

  it 'has the formatted availability date' do
    @information.available_from.should == 'Bezug ab Mai 2012'
  end

  it 'has the pure availability date' do
    @information.simple_available_from.should == 'Mai 2012'
  end

  it 'has a textual list of characteristics' do
    @information.characteristics.include?('Balkon').should be_true
    @information.characteristics.include?('Schwimmbecken').should be_true
  end

  it 'formats the maximal floor loading in kg' do
    @information.maximal_floor_loading.should == '140 kg'
  end

  it 'formats the freigh elevator carrying capacity in kg' do
    @information.freight_elevator_carrying_capacity.should == '150 kg'
  end
end
