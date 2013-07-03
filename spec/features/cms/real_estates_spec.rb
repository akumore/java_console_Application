# encoding: utf-8
require 'spec_helper'

describe "Cms::RealEstates" do
  create_category_tree

  before do
    Fabricate(:row_house_category)
  end

  describe "Visit cms_real_estates path" do
    login_cms_user

    before do
      @category = Fabricate :category, :name=>'single_house', :label=>'Einfamilienhaus'
      @reference = Reference.new
      @address = Fabricate.build(:address)
      @real_estate = Fabricate :real_estate, :category => @category, :reference => @reference, :address => @address
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

    it "has a link to copy the real estate" do
      within("#real_estate_#{@real_estate.id}") do
        page.should have_link "Diesen Eintrag kopieren", :href => copy_cms_real_estate_path(@real_estate)
      end
    end
  end

  describe '#new' do
    login_cms_user

    before :each do
      Fabricate(:employee, :firstname => 'Hans', :lastname => 'Muster')
      Fabricate(:office)
      visit new_cms_real_estate_path
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_path
    end

    it 'contains the right sort order numbers' do
      Category.top_level.map(&:sort_order).should include(1, 2)
    end

    context 'a valid RealEstate' do
      before :each do
        within(".new_real_estate") do
          select 'Child Category 1', :from => 'Objekt-Art'
          select 'Arbeiten', :from => 'Gebäudenutzung'
          select 'Camorino, TI', :from => 'Filiale'
          choose 'Kaufen'
          select 'Muster, Hans', :from => 'Kontaktperson'

          fill_in 'Titel', :with => 'My Real Estate'
          fill_in 'Beschreibung', :with => 'Some description...'
          fill_in 'Nutzungsarten', :with => 'Gewerbe, Hotel'
        end
      end

      it 'save a new RealEstate' do
        lambda do
          click_on 'Immobilie erstellen'
        end.should change(RealEstate, :count).from(0).to(1)
      end

      context '#create' do
        let :real_estate do
          RealEstate.last
        end

        it 'saves the category' do
          click_on 'Immobilie erstellen'
          real_estate.category.label.should == 'Child Category 1'
        end

        it 'saves the utilization type' do
          click_on 'Immobilie erstellen'
          real_estate.utilization.should == Utilization::WORKING
        end

        it 'saves the offer type' do
          click_on 'Immobilie erstellen'
          real_estate.offer.should == Offer::SALE
        end

        it 'enables it for the website' do
          check 'Website'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::WEBSITE_CHANNEL
        end

        it 'enables it for external real estate portal export' do
          check 'Externe Immobilienportale'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL
        end

        it 'enables it for the minidoku' do
          check 'Objektdokumentation'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::PRINT_CHANNEL
        end

        it 'enables it for micro-sites' do
          check 'Micro-Site'
          select 'Gartenstadt-Schlieren'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::MICROSITE_CHANNEL
        end

        it 'enables it for multiple channels' do
          check 'Website'
          check 'Externe Immobilienportale'
          click_on 'Immobilie erstellen'
          [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL, RealEstate::WEBSITE_CHANNEL].each do |channel|
            real_estate.channels.should include channel
          end
        end

        it 'assigns the contact person aka employee' do
          click_on 'Immobilie erstellen'
          real_estate.contact.fullname == 'Hans Muster'
        end

        it 'saves the title' do
          click_on 'Immobilie erstellen'
          real_estate.title.should == 'My Real Estate'
        end

        it 'saves the description' do
          click_on 'Immobilie erstellen'
          real_estate.description.should == 'Some description...'
        end

        it 'has saved the utilization description' do
          click_on 'Immobilie erstellen'
          real_estate.utilization_description.should == 'Gewerbe, Hotel'
        end

        it 'puts the real estate in the editing state' do
          click_on 'Immobilie erstellen'
          real_estate.state.should == RealEstate::STATE_EDITING
        end
      end
    end
  end


  describe '#edit' do
    login_cms_user

    before :each do
      @fabricated_real_estate = Fabricate(:real_estate, :reference => Reference.new, :category => Fabricate(:category))
      Fabricate(:employee, :firstname => 'Hanna', :lastname => 'Henker')
      visit edit_cms_real_estate_path(@fabricated_real_estate)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_real_estate_path(@fabricated_real_estate)
    end

    context '#update' do
      before :each do
        within(".edit_real_estate") do
          select 'Child Category 2', :from => 'Objekt-Art'
          select 'Wohnen', :from => 'Gebäudenutzung'
          choose 'Mieten'
          uncheck 'Website'
          check 'Objektdokumentation'
          select 'Henker, Hanna', :from => 'Kontaktperson'

          fill_in 'Titel', :with => 'My edited Real Estate'
          fill_in 'Beschreibung', :with => 'Some edited description...'
          fill_in 'Nutzungsarten', :with => 'Gewerbe, Hotel, Restaurant'
        end

        click_on 'Immobilie speichern'
      end

      it 'has updated the edited attributes' do
        @real_estate = RealEstate.find(@fabricated_real_estate.id)
        @real_estate.category.label.should == 'Child Category 2'
        @real_estate.utilization.should == Utilization::LIVING
        @real_estate.offer.should == Offer::RENT
        @real_estate.channels.should == %w(print)
        @real_estate.title.should == 'My edited Real Estate'
        @real_estate.contact.fullname.should == 'Hanna Henker'
        @real_estate.description.should == 'Some edited description...'
        @real_estate.utilization_description.should == 'Gewerbe, Hotel, Restaurant'
      end

      it 'has the Child Category 2 selected' do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
        find(:css, '#real_estate_category_id option[selected]').text.should == 'Child Category 2'
      end

      it 'has the contact Hanna Henker selected' do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
        find(:css, '#real_estate_contact_id option[selected]').text.should == 'Henker, Hanna'
      end
    end

    context 'when selecting a row house', :js => true do
      before do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
      end

      it 'shows the building type immediately' do
        select 'Reiheneinfamilienhaus', :from => 'Objekt-Art'
        page.should have_css('.building-type-container:not(.hidden)')
      end
    end

    context 'when choosing microsite', :js => true do
      before do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
      end

      it 'shows the microsite select options immediately' do
        check 'Micro-Site'
        page.should have_css('.microsite-options-container:not(.hidden)')
      end
    end

    context 'when the parking utilization is selected', :parking => true do
      before do
        select 'Parkieren', :from => 'Gebäudenutzung'
        click_on 'Immobilie speichern'
      end

      it 'shows the base data tab' do
        within('.nav-tabs') do
          page.should have_link('Stammdaten')
        end
      end

      it 'shows the address tab' do
        within('.nav-tabs') do
          page.should have_link('Adresse')
        end
      end

      it 'shows the infos tab' do
        within('.nav-tabs') do
          page.should have_link('Infos')
        end
      end

      it 'shows the pricing tab' do
        within('.nav-tabs') do
          page.should have_link('Preise')
        end
      end

      it 'does not show the figures tab' do
        within('.nav-tabs') do
          page.should_not have_link('Zahlen und Fakten')
        end
      end

      it 'shows the infrastructure tab' do
        within('.nav-tabs') do
          page.should have_link('Infrastruktur')
        end
      end

      it 'does not show the description tab' do
        within('.nav-tabs') do
          page.should_not have_link('Beschreibungen')
        end
      end

      it 'shows the images tab' do
        within('.nav-tabs') do
          page.should have_link('Bilder & Dokumente')
        end
      end
    end

    context 'when the living utilization is selected', :parking => true do
      before do
        select 'Wohnen', :from => 'Gebäudenutzung'
        click_on 'Immobilie speichern'
      end

      it 'shows the base data tab' do
        within('.nav-tabs') do
          page.should have_link('Stammdaten')
        end
      end

      it 'shows the address tab' do
        within('.nav-tabs') do
          page.should have_link('Adresse')
        end
      end

      it 'shows the infos tab' do
        within('.nav-tabs') do
          page.should have_link('Infos')
        end
      end

      it 'shows the pricing tab' do
        within('.nav-tabs') do
          page.should have_link('Preise')
        end
      end

      it 'shows the figures tab' do
        within('.nav-tabs') do
          page.should have_link('Zahlen und Fakten')
        end
      end

      it 'shows the infrastructure tab' do
        within('.nav-tabs') do
          page.should have_link('Infrastruktur')
        end
      end

      it 'shows the description tab' do
        within('.nav-tabs') do
          page.should have_link('Beschreibungen')
        end
      end

      it 'shows the images tab' do
        within('.nav-tabs') do
          page.should have_link('Bilder & Dokumente')
        end
      end
    end
  end

  describe "#copy" do
    shared_examples_for "Copying a real estate" do
      let :real_estate_copy do
        RealEstate.last
      end

      it "copies 'published' real estates" do
        Fabricate :residential_building, :state => RealEstate::STATE_PUBLISHED
        visit cms_real_estates_path

        expect {
          click_link "Diesen Eintrag kopieren"
        }.to change(RealEstate, :count).by(1)
        real_estate_copy
        current_path.should == edit_cms_real_estate_path(real_estate_copy)
      end

      it "copies to copy 'in_review' real estates" do
        Fabricate :residential_building, :state => RealEstate::STATE_IN_REVIEW, :creator => Fabricate(:cms_editor), :editor => Fabricate(:cms_editor)
        visit cms_real_estates_path

        expect {
          click_link "Diesen Eintrag kopieren"
        }.to change(RealEstate, :count).by(1)
        current_path.should == edit_cms_real_estate_path(real_estate_copy)
      end

      it "copies to copy not published real estates" do
        Fabricate :residential_building, :state => RealEstate::STATE_EDITING
        visit cms_real_estates_path

        expect {
          click_link "Diesen Eintrag kopieren"
        }.to change(RealEstate, :count).by(1)
        current_path.should == edit_cms_real_estate_path(real_estate_copy)
      end
    end

    context "As an editor" do
      login_cms_editor
      it_should_behave_like "Copying a real estate"
    end

    context "As an Admin" do
      login_cms_admin
      it_should_behave_like "Copying a real estate"
    end
  end

  describe 'invalid tab' do
    login_cms_user

    before do
      @real_estate = Fabricate :real_estate,:category => Fabricate(:category), :reference => Fabricate.build(:reference)
    end

    it 'is marked if the submodel is invalid' do
      visit edit_cms_real_estate_path(@real_estate)

      click_on('Publizieren')
      page.should have_css("li.invalid:contains(Adresse)")
      page.should have_css("li.invalid:contains(Preise)")
    end
  end

  describe '#destroy' do
    context 'as an admin' do
      login_cms_admin

      context 'a published real estate' do
        before :each do
          @published_real_estate = Fabricate(:published_real_estate,
            :category => Fabricate(:category),
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@published_real_estate)
        end

        it 'does not have a button to delete the real estate' do
          page.should_not have_link("Immobilie löschen")
        end
      end

      context 'an editable real estate' do
        before :each do
          @editable_real_estate = Fabricate(:real_estate,
            :category => Fabricate(:category),
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@editable_real_estate)
        end

        it 'has a button to delete the real estate' do
          page.should have_link("Immobilie löschen")
        end

        it 'deletes the real estate' do
          lambda {
            click_on "Immobilie löschen"
          }.should change(RealEstate, :count).by(-1)
        end

        it 'redirects to the real estate overview with a notification' do
          click_on 'Immobilie löschen'
          current_path.should == cms_real_estates_path
          within('#flash') do
            page.should have_content("Die Immobilie \"#{@editable_real_estate.title}\" wurde erfolgreich gelöscht.")
          end
        end
      end
    end

    context 'as an editor' do
      login_cms_editor

      context 'a published real estate' do
        it 'does not have a button to delete the real estate' do
          @published_real_estate = Fabricate(:published_real_estate,
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference)
        )
        visit edit_cms_real_estate_path(@published_real_estate)
          page.should_not have_link("Immobilie löschen")
        end
      end

      context 'an editable real estate' do
        before :each do
          @editable_real_estate = Fabricate(:real_estate,
            :category => Fabricate(:category),
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@editable_real_estate)
        end

        it 'has a button to delete the real estate' do
          page.should have_link("Immobilie löschen")
        end

        it 'deletes the real estate' do
          lambda {
            click_on "Immobilie löschen"
          }.should change(RealEstate, :count).by(-1)
        end

        it 'redirects to the real estate overview with a notification' do
          click_on 'Immobilie löschen'
          current_path.should == cms_real_estates_path
          within('#flash') do
            page.should have_content("Die Immobilie \"#{@editable_real_estate.title}\" wurde erfolgreich gelöscht.")
          end
        end
      end
    end
  end
end
