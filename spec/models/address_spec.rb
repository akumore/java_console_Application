# encoding: utf-8

require 'spec_helper'

describe Address do

  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :address => Address.new, :category => Fabricate(:category))
      @address = @real_estate.address
    end

    it 'does not pass validations' do
      @address.should_not be_valid
    end

    it 'requires a street' do
      @address.should have(1).error_on(:street)
    end

    it 'requires a zipcode' do
      @address.should have(1).error_on(:zip)
    end

    it 'requires a city' do
      @address.should have(1).error_on(:city)
    end

    it 'requires a canton' do
      @address.should have(2).error_on(:canton)
    end

    it 'has 5 errors' do
      @address.valid?
      @address.errors.should have(5).items
    end
  end

  describe 'geocoding' do
    before do
      @address = Fabricate.build(:address, :zip => '1234', :city => 'Herrnhut', :street => 'Christian-David-Straße', :street_number=>12, :canton => 'zh', :country => 'Deutschland')
    end

    it "collects address fields" do
      @address.address.should == "Christian-David-Straße 12, 1234, Herrnhut, zh, Deutschland"
    end

    describe 'manually updating coordinates' do
      it 'saves the lat and lng attributes into the location' do
        real_estate = Fabricate(:real_estate, :address => @address, :category => Fabricate(:category))
        @address.update_attributes(:lng => 123.4, :lat => 321.1, :manual_geocoding => true)
        @address.save
        @address.location.should == [123.4, 321.1]
      end
    end

    describe "detection of changes in geo-coding related fields" do
      before do
        Fabricate(:real_estate, :address => @address, :category => Fabricate(:category))
      end

      [:street, :street_number, :zip, :city, :canton, :country].each do |attr|
        it "detects changed attribute #{attr}" do
          @address.send("#{attr}=", "this value has changed")
          @address.address_changed?.should be_true
        end
      end
    end

    it 'geocodes itself on create' do
      mock_geocoding!(:coordinates => [8, 15])
      Fabricate :real_estate, :address => @address, :category => Fabricate(:category)
      @address.to_coordinates.should == [8, 15]
    end

    it 'geocodes itself when address is changing' do
      Fabricate :real_estate, :address => @address, :category => Fabricate(:category)
      mock_geocoding!(:coordinates => [5, 6])
      @address.update_attributes :street => 'A new street'

      @address.to_coordinates.should == [5, 6]
    end
  end
end
