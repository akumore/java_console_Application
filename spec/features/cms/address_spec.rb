# encoding: utf-8
require 'spec_helper'

describe "Cms::Addresses" do
  login_cms_user
  create_category_tree

  describe '#new' do
    before :each do
      @real_estate = Fabricate(:real_estate,
        :category => Category.last,
        :reference => Fabricate.build(:reference),
        :channels => [RealEstate::WEBSITE_CHANNEL]
      )
      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Adresse'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_address_path(@real_estate)
    end

    it 'doesnt render the reference number fields' do
      page.should_not have_css('#address_reference_property_key')
      page.should_not have_css('#address_reference_building_key')
      page.should_not have_css('#address_reference_unit_key')
    end

    it 'doesnt render the microsite reference fields' do
      page.should_not have_css('#address_microsite_reference_property_key')
      page.should_not have_css('#address_microsite_reference_building_key')
    end

    context 'a valid Address' do
      before :each do
        within(".new_address") do
          fill_in 'Strasse', :with => 'Bahnhofstrasse'
          fill_in 'Hausnummer', :with => '5'
          fill_in 'Postleitzahl', :with => '8123'
          fill_in 'Ort', :with => 'Adliswil'
          select 'Zürich', :from => 'Kanton'
          fill_in 'Link', :with => 'http://www.google.ch'
          uncheck 'Geokoordinaten manuell eintragen'
        end
      end

      it 'saves a new Address' do
        click_on 'Adresse erstellen'
        @real_estate.reload
        @real_estate.address.should be_a(Address)
      end

      context '#create' do
        before :each do
          click_on 'Adresse erstellen'
          @real_estate.reload
          @address = @real_estate.address
        end

        it 'has saved the provided attributes' do
          @address.street.should == 'Bahnhofstrasse'
          @address.street_number.should == '5'
          @address.city.should == 'Adliswil'
          @address.zip.should == '8123'
          @address.canton.should == 'zh'
          @address.link_url.should == 'http://www.google.ch'
          @address.manual_geocoding.should be_false
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @real_estate = Fabricate(:real_estate,
        :reference => Reference.new,
        :category => Fabricate(:category),
        :reference => Reference.new,
        :address => Fabricate.build(:address))

      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Adresse'
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_real_estate_address_path(@real_estate)
    end

    context '#update' do
      before :each do
        within(".edit_address") do
          fill_in 'Strasse', :with => 'Schaffhauserstrasse'
          fill_in 'Hausnummer', :with => '2'
          fill_in 'Ort', :with => 'Adliswil'
          fill_in 'Postleitzahl', :with => '8135'
          select 'Schaffhausen', :from => 'Kanton'
          fill_in 'Link', :with => 'http://www.google.com'
          check 'Geokoordinaten manuell eintragen'
        end

        click_on 'Adresse speichern'
        @real_estate.reload
        @address = @real_estate.address
      end

      it 'has updated the edited attributes' do
        @address.street.should == 'Schaffhauserstrasse'
        @address.street_number.should == '2'
        @address.city.should == 'Adliswil'
        @address.zip.should == '8135'
        @address.canton.should == 'sh'
        @address.link_url.should == 'http://www.google.com'
        @address.manual_geocoding.should be_true
      end
    end
  end

  context 'when the real estate is to be published to homegate' do
    before do
      @real_estate = Fabricate(:real_estate,
        :category => Fabricate(:category),
        :address => Fabricate.build(:address,
          :reference => Fabricate.build(:reference)
        ),
        :reference => Fabricate.build(:reference),
        :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL]
      )
      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Adresse'
    end

    it 'shows the reference fields' do
      page.should have_css('#address_reference_property_key', :count => 1)
      page.should have_css('#address_reference_building_key', :count => 1)
      page.should have_css('#address_reference_unit_key', :count => 1)
    end

    describe '#update with invalid reference numbers' do
      before :each do
        fill_in 'Liegenschaftsreferenz', :with => ''
        fill_in 'Gebäudereferenz', :with => ''
        fill_in 'Objektreferenz', :with => ''
        click_on 'Adresse speichern'
      end

      it 'requires at least one reference number' do
        page.should have_content 'Referenznummer muss ausgefüllt werden'
      end
    end
  end

  context 'when the real estate is to be on a microsite' do
    let :real_estate do
      Fabricate(:real_estate,
        :category => Fabricate(:category),
        :address => Fabricate.build(:address),
        :channels => [RealEstate::MICROSITE_CHANNEL],
        :microsite_building_project => MicrositeBuildingProject::GARTENSTADT
      )
    end

    before do
      visit edit_cms_real_estate_path(real_estate)
      click_on 'Adresse'
    end

    it 'shows the microsite reference fields' do
      page.should have_css('#address_microsite_reference_property_key', :count => 1)
      page.should have_css('#address_microsite_reference_building_key', :count => 1)
    end

    describe '#update with valid microsite reference numbers' do
      before :each do
        within(".microsite_reference") do
          fill_in 'Hausnummer', :with => 'H'
          fill_in 'Immobiliennummer', :with => '22.34'
        end
        click_on 'Adresse speichern'
        real_estate.reload
      end

      it 'stores the property_key' do
        real_estate.address.microsite_reference.property_key.should == '22.34'
      end

      it 'stores the building_key' do
        real_estate.address.microsite_reference.building_key.should == 'H'
      end
    end
  end

end
