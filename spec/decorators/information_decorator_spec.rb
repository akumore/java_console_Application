# encoding: utf-8
require 'spec_helper'

describe InformationDecorator do
  before { ApplicationController.new.set_current_view_context }

  before :each do
    @real_estate = Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :offer => Offer::RENT,
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

  context 'with an estimate avilability date' do
    it 'has the formatted availability date' do
      @information.available_from_compact.should == 'ab Mai 2012'
    end

    it 'has the pure availability date' do
      @information.available_from.should == 'Mai 2012'
    end
  end

  context 'without an estimate availability date' do
    before :each do
      @real_estate.information.stub!(:display_estimated_available_from).and_return(nil)
    end

    it 'has the formatted availability date' do
      @real_estate.information.stub!(:available_from).and_return(Date.parse('20.05.2030'))
      @information.available_from_compact.should == 'ab 20.05.2030'
    end

    it 'has the pure availability date' do
      @real_estate.information.stub!(:available_from).and_return(Date.parse('20.05.2030'))
      @information.available_from.should == '20.05.2030'
    end

    it 'shows past availability dates as immediately available' do
      @real_estate.information.stub!(:available_from).and_return(Date.parse('20.05.1986'))
      @information.available_from.should == 'sofort'
    end
  end

  it 'has a textual list of characteristics' do
    @information.characteristics.include?('Balkon').should be_true
    @information.characteristics.include?('Schwimmbecken').should be_true
  end

  it 'formats the maximal floor loading in kg' do
    @information.maximal_floor_loading.should == '140 kg / m²'
  end

  it 'formats the freigh elevator carrying capacity in kg' do
    @information.freight_elevator_carrying_capacity.should == '150 kg'
  end
end
