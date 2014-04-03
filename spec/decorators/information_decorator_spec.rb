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
    @information.maximal_floor_loading.should == '140 kg/m²'
  end

  it 'formats the freigh elevator carrying capacity in kg' do
    @information.freight_elevator_carrying_capacity.should == '150 kg'
  end

  describe '#chapter "Immobilieninfos"' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        category: Fabricate(:category),
        information: Fabricate.build(:information),
        figure: Fabricate.build(:figure,
          floor: 1,
          rooms: '2.5',
          living_surface: 125,
          floors: 3,
          renovated_on: 2014,
          built_on: 2014
        )
      )
      @information_decorator = InformationDecorator.new(@real_estate.information)
    end

    describe 'key "Zimmeranzahl"' do
      it 'returns "2.5 Zimmer" for rooms = "2.5"' do
        value  = ''
        @information_decorator.chapter()[:content].each do |element|
          value = element[:value] if element[:key] == 'Zimmeranzahl'
        end
        expect(value).to eq '2.5 Zimmer'
      end

      it 'does not return a key, value pair for "Zimmeranzahl" if rooms = "0"' do
        @real_estate.figure.rooms = '0'
        value  = ''
        @information_decorator.chapter()[:content].each do |element|
          value = element[:value] if element[:key] == 'Zimmeranzahl'
        end
        expect(value).to be_empty
      end
    end

    describe 'keys "Wohnfläche", "Nutzfläche", "Grundstückfläche", "Lagerfläche"' do
      context 'living utilization' do
        it 'returns the right surface' do
          @real_estate.figure.living_surface = '33' # Wohnfläche
          living_surface  = ''
          working_surfaces = []
          @information_decorator.chapter()[:content].each do |element|
            living_surface = element[:value] if element[:key] == 'Wohnfläche'
            working_surfaces << element[:value] if element[:key] == 'Nutzfläche' || element[:key] == 'Grundstückfläche' || element[:key] == 'Lagerfläche'
          end
          expect(living_surface).to eq '33 m²'
          expect(working_surfaces).to be_empty
        end
      end

      context 'working utilization' do
        it 'returns the right surfaces' do
          @real_estate.utilization = Utilization::WORKING
          @real_estate.figure.usable_surface = '44' # Nutzfläche
          @real_estate.figure.property_surface = '55' # Grundstückfläche
          @real_estate.figure.storage_surface = '66' # Lagerfläche
          living_surface = ''
          working_surfaces  = []
          @information_decorator.chapter()[:content].each do |element|
            working_surfaces << element[:value] if element[:key] == 'Nutzfläche' || element[:key] == 'Grundstückfläche' || element[:key] == 'Lagerfläche'
          end
          expect(working_surfaces).to eq ['44 m²', '55 m²', '66 m²']
          expect(living_surface).to be_empty
        end
      end
    end
  end
end
