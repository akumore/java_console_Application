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

    @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'shopping', :distance => 200)
    @real_estate.information.points_of_interest << PointOfInterest.new(:name => 'public_transport', :distance => 100)
    @information = InformationDecorator.new(@real_estate.information)
  end

  it 'has a textual list of characteristics' do
    @information.characteristics.include?('Balkon').should be_true
    @information.characteristics.include?('Schwimmbecken').should be_true
  end

  it 'formats the maximal floor loading in kg' do
    @information.maximal_floor_loading.should == '140 kg/m²'
  end

  it 'adds additional no information if nothing selected' do
    @information.has_balcony = false
    @information.has_swimming_pool = false
    @information.additional_information.should == 'Ergänzende Informationen zum Ausbau'
    @information.update_list_in(:characteristics, :additional_information).should be_false
    @information.additional_information.should == 'Ergänzende Informationen zum Ausbau'
  end

  it 'adds additional information' do
    @information.additional_information.should == 'Ergänzende Informationen zum Ausbau'
    @information.update_list_in(:characteristics, :additional_information).should be_true
    @information.additional_information.should == [
      '<ul>',
      "\t<li>Balkon</li>",
      "\t<li>Schwimmbecken</li>",
      '</ul>',
      'Ergänzende Informationen zum Ausbau'].join("\r\n")
  end

  context 'updated additional information' do
    before(:each) do
      @information.update_list_in(:characteristics, :additional_information)
    end

    it 'adds a new characteristic' do
      @information.has_elevator = true
      @information.update_list_in(:characteristics, :additional_information).should be_true
      @information.additional_information.should == [
        '<ul>',
        "\t<li>Balkon</li>",
        "\t<li>Schwimmbecken</li>",
        "\t<li>Liftzugang</li>",
        '</ul>',
        'Ergänzende Informationen zum Ausbau'].join("\r\n")
    end

    it 'adds a new characteristic with user changes' do
      @information.has_elevator = true
      @information.additional_information = ("some text\r\n" * 3) + @information.additional_information
      @information.additional_information = @information.additional_information.gsub('Balkon', 'Grosser Balkon')
      @information.additional_information = @information.additional_information.gsub('Schwimmbecken', 'Jacuzzi')

      @information.update_list_in(:characteristics, :additional_information).should be_true
      @information.additional_information.should == [
        'some text',
        'some text',
        'some text',
        '<ul>',
        "\t<li>Grosser Balkon</li>",
        "\t<li>Jacuzzi</li>",
        "\t<li>Liftzugang</li>",
        '</ul>',
        'Ergänzende Informationen zum Ausbau'].join("\r\n")
    end
  end

  it 'formats the freigh elevator carrying capacity in kg' do
    @information.freight_elevator_carrying_capacity.should == '150 kg'
  end

  it 'formats the number of floors' do
    @information.floors.should == '2 Geschosse'
    @information.update_attribute :floors, 1
    @information.floors.should == '1 Geschoss'
  end

  it 'formats the ceiling height' do
    @information.ceiling_height.should == '2.55 m'
  end

  describe '#distances' do
    it 'formats points of interest' do
      @information.distances.should == ['Einkaufen 200 m', 'Öffentlicher Verkehr 100 m']
    end
  end
end
