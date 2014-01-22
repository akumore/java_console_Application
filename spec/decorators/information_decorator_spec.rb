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

  it 'creates lis correctly' do
    @information.characteristics_lis.should == ["\t<li>Balkon</li>", "\t<li>Schwimmbecken</li>"]
  end

  it 'creates lis in different language' do
    I18n.locale.should == :de
    @information.real_estate.language = 'it'
    @information.characteristics_lis.should == ["\t<li>Balcone</li>", "\t<li>Piscina</li>"]
    I18n.locale.should == :de
  end

  it 'formats the maximal floor loading in kg' do
    @information.maximal_floor_loading.should == '140 kg/m²'
  end

  it 'adds additional information' do
    @information.additional_information.should == 'Ergänzende Informationen zum Ausbau'
    @information.update_additional_information
    @information.additional_information.should == [
      '<ul>',
      "\t<li>Balkon</li>",
      "\t<li>Schwimmbecken</li>",
      '</ul>',
      'Ergänzende Informationen zum Ausbau'].join("\r\n")
  end

  context 'updated additional information' do
    before(:each) do
      @information.update_additional_information
    end

    it 'adds a new characteristic' do
      @information.has_elevator = true
      @information.update_additional_information
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
      p @information.additional_information
      @information.update_additional_information
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
end
