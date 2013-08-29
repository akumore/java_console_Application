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

    it 'initialized the microsite reference object' do
      @address.microsite_reference.should be_a(MicrositeReference)
    end
  end

  describe 'Reference keys' do
    it 'is invalid if children are not valid'
  end

  describe Reference do
    let(:reference_attributes) { Fabricate.attributes_for(:reference) }
    let(:real_estate) { Fabricate.build(:real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL], :address => Fabricate.build(:address, :reference => Fabricate.build(:reference, reference_attributes)), :category => Fabricate(:category)) }
    let(:published_real_estate) { Fabricate.build(:published_real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL], :address => Fabricate.build(:address, :reference => Fabricate.build(:reference, reference_attributes)), :category => Fabricate(:category)) }

    context 'with channel external realestate portal set' do
      context 'with published real estate and saved reference in database' do
        before do
          expect(published_real_estate.save).to be_true
        end

        it "shouldn't be possible to save the reference with the same keys" do
          expect(Address.exists_by_attributes?(reference_attributes)).to be_true
          real_estate_from_santa_claus = Fabricate.build(:published_real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL], :category => Fabricate(:category))
          real_estate_from_santa_claus.address = Fabricate.build(:address, :city => 'Steinhausen', :reference => Fabricate.build(:reference, reference_attributes))
          expect(real_estate_from_santa_claus.address).not_to be_valid
          expect(real_estate_from_santa_claus).not_to be_valid
          expect(real_estate_from_santa_claus.save).to be_false
        end
      end

      context 'with unpublished real estate and reference in database' do
        before :each do
          expect(real_estate.save).to be_true
        end

        it "shouldn't be possible to save the reference with the same keys" do
          expect(Address.exists_by_attributes?(reference_attributes)).to be_true
          real_estate_from_santa_claus = Fabricate.build(:real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL], :category => Fabricate(:category))
          real_estate_from_santa_claus.address = Fabricate.build(:address, :city => 'Steinhausen', :reference => Fabricate.build(:reference, reference_attributes))
          expect(real_estate_from_santa_claus.address).not_to be_valid
          expect(real_estate_from_santa_claus).to be_valid
          expect(real_estate_from_santa_claus.save).to be_true
        end

        context "should be possible to save the reference with different keys" do
          let(:schmutzli_reference_attributes) { Fabricate.attributes_for(:reference, :property_key => 'HUHU') }
          let(:real_estate_from_schmutzli) { Fabricate.build(:real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL], :address => Fabricate.build(:address, :reference => Fabricate.build(:reference, schmutzli_reference_attributes)), :category => Fabricate(:category)) }

          it "should be possible to save the reference" do
            expect(real_estate_from_schmutzli.address).to be_valid
            expect(real_estate_from_schmutzli).to be_valid
            expect(real_estate_from_schmutzli.save).to be_true
          end
        end
      end

      context 'without channel external realestate portal set' do
        it "should be possible to save the reference" do
          real_estate_from_schmutzli = Fabricate.build(:real_estate, :address => Fabricate.build(:address, :reference => Fabricate.build(:reference, reference_attributes)), :category => Fabricate(:category))
          expect(real_estate_from_schmutzli.address).to be_valid
          expect(real_estate_from_schmutzli).to be_valid
          expect(real_estate_from_schmutzli.save).to be_true
        end
      end
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

      it "doesn't detect changes in other fields" do
        @address.link_url = "test link"
        @address.address_changed?.should be_false
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

    it "doesn't geocode on update without address changing" do
      Fabricate :real_estate, :address => @address, :category => Fabricate(:category)
      mock_geocoding!(:coordinates => [5, 6])
      @address.update_attributes :link_url => "www.heise.de"

      @address.to_coordinates.should_not == [5, 6]
    end
  end
end
