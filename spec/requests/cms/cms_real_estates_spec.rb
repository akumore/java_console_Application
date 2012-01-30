# encoding: utf-8
require 'spec_helper'

describe "Cms::RealEstates" do
  login_cms_user
  create_category_tree

  describe "Visit cms_real_estates path" do
    before do
      @category = Fabricate :category, :name=>'single_house', :label=>'Einfamilienhaus'
      @reference = Reference.new
      @address = Address.new
      @real_estate = Fabricate :real_estate, :category=>@category, :reference=>@reference, :address => @address
      visit cms_real_estates_path
    end

    it "shows the list of real estates" do
      page.should have_selector('table tr', :count => RealEstate.count+1)
    end

    it "shows the expected real estate attributes" do
      within("#real_estate_#{@real_estate.id}") do
        page.should have_content @real_estate.address.city
        page.should have_content @real_estate.title
        page.should have_content I18n.t("cms.real_estates.index.#{@real_estate.offer}")
        page.should have_content I18n.t("cms.real_estates.index.#{@real_estate.utilization}")
        page.should have_content I18n.t("cms.real_estates.index.#{@real_estate.state}")
      end
    end

    it "takes me to the edit page of a certain real estate" do
      within("#real_estate_#{@real_estate.id}") do
        page.click_link I18n.t('cms.real_estates.index.edit')
      end
      current_path.should == edit_cms_real_estate_path(@real_estate)
    end

    it "takes me to the page for creating a new real estate" do
      page.click_link I18n.t('cms.real_estates.index.new')
      current_path.should == new_cms_real_estate_path
    end
  end


  describe '#new' do
    before :each do
      visit new_cms_real_estate_path
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_path
    end

    context 'a valid RealEstate' do
      before :each do
        within(".new_real_estate") do
          select 'Child Category 1', :from => 'Kategorie'
          choose 'Gewerblich'
          choose 'Kaufen'
          check 'Erstvermarktung'
          check 'Website'
          check 'Homegate'

          fill_in 'Titel', :with => 'My Real Estate'
          fill_in 'Liegenschaftsname', :with => 'Gartenstadt'
          fill_in 'Beschreibung', :with => 'Some description...'
          fill_in 'Kurzbeschreibung', :with => 'Some short description...'
          fill_in 'Schlüsselwörter', :with => 'Premium, Realty'
          fill_in 'Liegenschaftsreferenz', :with => 'LR12345'
          fill_in 'Gebäudereferenz', :with => 'GR12345'
          fill_in 'Objektreferenz', :with => 'OR12345'
          fill_in 'Nutzungsarten', :with => 'Gewerbe, Hotel'
        end
      end

      it 'save a new RealEstate' do
        lambda do
          click_on 'Immobilie erstellen'
        end.should change(RealEstate, :count).from(0).to(1)
      end

      context '#create' do
        before :each do
          click_on 'Immobilie erstellen'
          @real_estate = RealEstate.last
        end

        it 'has saved the provided attributes' do
          @real_estate.category.label.should == 'Child Category 1'
          @real_estate.utilization.should == RealEstate::UTILIZATION_COMMERICAL
          @real_estate.offer.should == RealEstate::OFFER_FOR_SALE
          @real_estate.is_first_marketing.should == true
          @real_estate.channels.should == %w(website homegate)
          @real_estate.title.should == 'My Real Estate'
          @real_estate.property_name.should == 'Gartenstadt'
          @real_estate.description.should == 'Some description...'
          @real_estate.short_description.should == 'Some short description...'
          @real_estate.keywords.should == 'Premium, Realty'
          @real_estate.reference.property_key.should == 'LR12345'
          @real_estate.reference.building_key.should == 'GR12345'
          @real_estate.reference.unit_key.should == 'OR12345'
          @real_estate.utilization_description.should == 'Gewerbe, Hotel'
        end

        it 'is in the editing state' do
          @real_estate.state.should == RealEstate::STATE_EDITING
        end
      end
    end
  end


  describe '#edit' do
    before :each do
      @fabricated_real_estate = Fabricate(:real_estate, :reference => Reference.new)
      visit edit_cms_real_estate_path(@fabricated_real_estate)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_real_estate_path(@fabricated_real_estate)
    end

    context '#update' do
      before :each do
        within(".edit_real_estate") do
          select 'Child Category 2', :from => 'Kategorie'
          choose 'Privat'
          choose 'Mieten'
          uncheck 'Erstvermarktung'
          uncheck 'Website'
          check 'Mini Doku'

          fill_in 'Titel', :with => 'My edited Real Estate'
          fill_in 'Liegenschaftsname', :with => 'Gartenstadt 2012'
          fill_in 'Beschreibung', :with => 'Some edited description...'
          fill_in 'Kurzbeschreibung', :with => 'Some edited short description...'
          fill_in 'Schlüsselwörter', :with => 'Premium, Realty, Edit'
          fill_in 'Liegenschaftsreferenz', :with => 'E_LR12345'
          fill_in 'Gebäudereferenz', :with => 'E_GR12345'
          fill_in 'Objektreferenz', :with => 'E_OR12345'
          fill_in 'Nutzungsarten', :with => 'Gewerbe, Hotel, Restaurant'
        end

        click_on 'Immobilie speichern'
      end

      it 'has updated the edited attributes' do
        @real_estate = RealEstate.find(@fabricated_real_estate.id)
        @real_estate.category.label.should == 'Child Category 2'
        @real_estate.utilization.should == RealEstate::UTILIZATION_PRIVATE
        @real_estate.offer.should == RealEstate::OFFER_FOR_RENT
        @real_estate.is_first_marketing.should == false
        @real_estate.channels.should == %w(print)
        @real_estate.title.should == 'My edited Real Estate'
        @real_estate.property_name.should == 'Gartenstadt 2012'
        @real_estate.description.should == 'Some edited description...'
        @real_estate.short_description.should == 'Some edited short description...'
        @real_estate.keywords.should == 'Premium, Realty, Edit'
        @real_estate.reference.property_key.should == 'E_LR12345'
        @real_estate.reference.building_key.should == 'E_GR12345'
        @real_estate.reference.unit_key.should == 'E_OR12345'
        @real_estate.utilization_description.should == 'Gewerbe, Hotel, Restaurant'
      end

      it 'has the Child Category 2 selected' do
        find(:css, '#real_estate_category_id option[selected]').text.should == 'Child Category 2'
      end
    end
  end

end
