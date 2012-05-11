# encoding: utf-8

require 'spec_helper'

describe MicrositeDecorator do
  # workaround for issue: https://github.com/jcasimir/draper/issues/60
  # include Rails.application.routes.url_helpers
  # before :all do
  #   c = ApplicationController.new
  #   c.request = ActionDispatch::TestRequest.new
  #   c.set_current_view_context
  # end
  # end of workaround
  #

  context "When the number of rooms is defined" do

    before do
      @real_estate =  Fabricate :residential_building,
        :figure => Fabricate.build(:figure, :rooms => '1.5')
      @decorated_real_estate = MicrositeDecorator.decorate @real_estate
    end

    it 'returns the correct value' do
      @decorated_real_estate.rooms.should == '1.5'
    end

  end

  context "with correct net price" do

    it 'returns the rendered net price' do
      real_estate =  Fabricate :residential_building,
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 2500)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should == 'CHF 2500'
    end

  end

  context "with incorrect net price" do

    it 'returns the net rent price without extras' do
      real_estate =  Fabricate :residential_building,
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 2500, :for_rent_extra => 200)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should == 'CHF 2500'
    end

    it 'returns nil if no pricing is specified' do
      real_estate =  Fabricate :residential_building,
        :pricing => nil
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should be_nil
    end

    it 'returns nil if no for_rent_netto is specified' do
      real_estate =  Fabricate :residential_building
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should be_nil
    end

  end

  context "with correct address" do

    it 'returns the corresponding house-name' do
      for street_number, house_name in MicrositeDecorator::STREET_NUMBER_HOUSE_MAP
        street = "Badenerstrasse"
        real_estate =  Fabricate :residential_building,
          :address => Fabricate.build(:address, :street => street, :street_number => street_number)
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.house.should == house_name
      end
    end
  end

  context "with incorrect address" do

    it 'returns nil for unmapped address' do
      real_estate =  Fabricate :residential_building,
        :address => Fabricate.build(:address, :street => 'Büchsenweg', :street_number => 30)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.house.should be_nil
    end

  end

  context "with assigned floor number" do

    it 'returns the rendered floor name' do
      for floor, floor_label in MicrositeDecorator::FLOOR_FLOOR_LABEL_MAP
        real_estate =  Fabricate :residential_building,
          :figure => Fabricate.build(:figure, :floor => floor)
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.floor_label.should == floor_label
      end
    end

  end

  context "with a valid surface" do
    context "for a residential building" do

      it 'returns the living surface' do
        real_estate =  Fabricate :residential_building,
          :figure => Fabricate.build(:figure, :living_surface => '50')
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.floor_label.should == '50m²'
      end

    end

    context "for a commercial building" do

      it 'returns the useable surface' do
        real_estate =  Fabricate :residential_building,
          :figure => Fabricate.build(:figure, :useable_surface => '50')
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.floor_label.should == '50m²'
      end

    end
  end

  context "with assigned id" do

    it 'returns model\'s id' do
      real_estate =  Fabricate :real_estate, :category=>Fabricate(:category)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.id.should == real_estate.id
    end

  end
end
