# encoding: utf-8

require 'spec_helper'

describe Address do
  before do
    @address = Fabricate.build(:address, :zip => nil, :city => 'Herrnhut', :street => 'Christian-David-Straße 12', :canton => nil, :country => 'Deutschland')
  end

  it "collects address fields" do
    @address.address.should == "Christian-David-Straße 12, Herrnhut, Deutschland"
  end


  describe "detection of changes in geo-coding related fields" do
    before do
      Fabricate(:real_estate, :address => @address)
    end

    [:street, :zip, :city, :canton, :country].each do |attr|
      it "detects changed attribute #{attr}" do
        @address.send("#{attr}=", "this value has changed")
        @address.address_changed?.should be_true
      end
    end

    it "doesn't detect changes in other fields" do
      @address.link_url = "test link"
      @address.address_changed?.should be_false
    end
  end


  it 'geocodes itself on create' do
    mock_geocoding!(:coordinates => [8, 15])
    Fabricate :real_estate, :address => @address
    @address.to_coordinates.should == [8, 15]
  end

  it 'geocodes itself when address is changing' do
    Fabricate :real_estate, :address => @address
    mock_geocoding!(:coordinates => [5, 6])
    @address.update_attributes :street => 'A new street'

    @address.to_coordinates.should == [5, 6]
  end

  it "doesn't geocode on update without address changing" do
    Fabricate :real_estate, :address => @address
    mock_geocoding!(:coordinates => [5, 6])
    @address.update_attributes :link_url => "www.heise.de"

    @address.to_coordinates.should_not == [5, 6]
  end
end
