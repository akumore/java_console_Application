# encoding: utf-8
require 'spec_helper'

describe "Cms::Addresses" do
  login_cms_user
  create_category_tree

  describe '#new' do
    before :each do
      @real_estate = Fabricate(:real_estate, :category => Category.last, :reference => Fabricate.build(:reference) )
      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Adresse'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_address_path(@real_estate)
    end

    context 'a valid Address' do
      before :each do
        within(".new_address") do
          fill_in 'Strasse', :with => 'Bahnhofstrasse'
          fill_in 'Hausnummer', :with => '5'
          fill_in 'Postleitzahl', :with => '8123'
          fill_in 'Stadt', :with => 'Adliswil'
          select 'Zürich', :from => 'Kanton'
          fill_in 'Link', :with => 'http://www.google.ch'
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
          fill_in 'Stadt', :with => 'Adliswil'
          fill_in 'Postleitzahl', :with => '8135'
          select 'Schaffhausen', :from => 'Kanton'
          fill_in 'Link', :with => 'http://www.google.com'
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
      end
    end
  end

end
