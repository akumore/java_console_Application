# encoding: utf-8
require 'spec_helper'

describe InformationDecorator do
  before { ApplicationController.new.set_current_view_context }

  before :each do
    @real_estate = Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :offer => Offer::RENT,
      :information => Fabricate.build(:information,
        :has_balcony => true,
        :has_swimming_pool => true,
        :maximal_floor_loading => 140,
        :freight_elevator_carrying_capacity => 150,
        :floors => 2,
        :ceiling_height => '2.55'
      )
    )
    @real_estate.information.interior_html = 'Infrastructure description'

    @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'shopping', :distance => 200)
    @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'public_transport', :distance => 100)
    @information = InformationDecorator.new(@real_estate.information)
  end

  it 'has a textual list of characteristics' do
    @information.interior_characteristics.include?('Balkon').should be_true
    @information.infrastructure_characteristics.include?('Schwimmbecken').should be_true
  end

  it 'formats the maximal floor loading in kg' do
    @information.maximal_floor_loading.should == 'Maximale Bodenbelastung: 140 kg/m²'
  end

  it 'adds additional no information if nothing selected' do
    @information.has_balcony = false
    @information.has_swimming_pool = false
    @information.infrastructure_html = 'Infrastructure description'
    @information.update_list_in(:infrastructure)
    @information.infrastructure_html.should == 'Infrastructure description'
  end

  it 'adds infrastructure information' do
    @information.infrastructure_html.should == [
      '<ul>',
      "\t<li>Baujahr: 1899</li>",
      "\t<li>Letzte Renovierung: 1997</li>",
      "\t<li>2 Geschosse</li>",
      "\t<li>Schwimmbecken</li>",
      '</ul>',
      'Infrastructure description'].join("\r\n")
  end

  context 'updated additional information' do
    before(:each) do
      @information.update_list_in(:interior)
    end

    it 'adds new characteristic' do
      @information.has_elevator = true
      @information.update_list_in(:infrastructure)
      @information.infrastructure_html.should == [
        '<ul>',
        "\t<li>Baujahr: 1899</li>",
        "\t<li>Letzte Renovierung: 1997</li>",
        "\t<li>2 Geschosse</li>",
        "\t<li>Schwimmbecken</li>",
        "\t<li>Liftzugang</li>",
        '</ul>',
        'Infrastructure description'].join("\r\n")
    end

    it 'adds a new characteristic with user changes' do
      @information.has_elevator = true
      @information.infrastructure_html = ("some text\r\n" * 3) + @information.infrastructure_html
      @information.infrastructure_html = @information.infrastructure_html.gsub('Schwimmbecken', 'Jacuzzi')

      @information.update_list_in(:infrastructure)
      @information.infrastructure_html.should == [
        'some text',
        'some text',
        'some text',
        '<ul>',
        "\t<li>Baujahr: 1899</li>",
        "\t<li>Letzte Renovierung: 1997</li>",
        "\t<li>2 Geschosse</li>",
        "\t<li>Liftzugang</li>",
        "\t<li>Jacuzzi</li>",
        '</ul>',
        'Infrastructure description'].join("\r\n")
    end
  end

  it 'formats the freigh elevator carrying capacity in kg' do
    @information.freight_elevator_carrying_capacity.should == 'Maximales Gewicht für Warenlift: 150 kg'
  end

  it 'formats the number of floors' do
    @information.floors.should == '2 Geschosse'
    @information.update_attribute :floors, 1
    @information.floors.should == '1 Geschoss'
  end

  it 'formats the ceiling height' do
    @information.ceiling_height.should == 'Raumhöhe: 2.55 m'
  end

  describe '#location_characteristics' do
    it 'formats points of interest' do
      expect(@information.location_characteristics).to eq ['Öffentlicher Verkehr 100 m', 'Einkaufen 200 m']
    end

    it 'puts school and transport on same line' do
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'high_school', :distance => 20)
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'elementary_school', :distance => 20)
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'highway_access', :distance => 30)
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'kindergarden', :distance => 20)

      expect(@information.points_of_interest.count).to eq(6)
      expect(@information.location_characteristics).to eq ['Öffentlicher Verkehr 100 m, Autobahnanschluss 30 m',
                                            'Kindergarten 20 m, Primarschule 20 m, Oberstufe 20 m',
                                            'Einkaufen 200 m']
      expect(@information.points_of_interest.count).to eq(6)
    end

    it 'do not use emtpy location_characteristics' do
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'high_school', :distance => '')
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'elementary_school', :distance => '')
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'highway_access', :distance => '')
      @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'kindergarden', :distance => '')

      expect(@information.points_of_interest.count).to eq(6)
      expect(@information.location_characteristics).to eq ['Öffentlicher Verkehr 100 m',
                                            'Einkaufen 200 m']
      expect(@information.points_of_interest.count).to eq(6)
    end
  end

  describe '#infrastructure_characteristics' do

    it 'create a translated list' do
      @real_estate.utilization = Utilization::WORKING
      expect(@information.working?).to be_true
      expect(@information.infrastructure_characteristics).to eq ["Baujahr: 1899", "Letzte Renovierung: 1997", "2 Geschosse", "Maximales Gewicht für Warenlift: 150 kg"]
    end

    it 'respect acessibility' do
      @real_estate.utilization = Utilization::LIVING
      expect(@information.living?).to be_true
      expect(@information.infrastructure_characteristics).to eq ["Baujahr: 1899", "Letzte Renovierung: 1997", "2 Geschosse", "Schwimmbecken"]
    end

    it 'parking has no infrastructure' do
      @real_estate.utilization = Utilization::PARKING
      expect(@information.parking?).to be_true
      expect(@information.infrastructure_characteristics).to eq []
    end
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
