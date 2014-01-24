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
      @figure = Fabricate.build(:figure, :floor => 3)
      @contact = Fabricate(:employee)
      @real_estate = Fabricate :real_estate, 
                               :category => @category, 
                               :reference => @reference, 
                               :address => @address,
                               :figure => @figure,
                               :contact => @contact
      visit cms_real_estates_path
    end

    describe 'filter tabs' do
      it "shows a filter tab for 'Alle', 'Veröffentlicht' and 'in Bearbeitung'" do
        page.should have_link(I18n.t('cms.real_estates.index.tabs.all'))
        page.should have_link(I18n.t('cms.real_estates.index.tabs.published'))
        page.should have_link(I18n.t('cms.real_estates.index.tabs.in_progress'))
      end

      it "has the 'Alle' tab activated by default" do
        page.should have_css("li.active:contains(#{I18n.t('cms.real_estates.index.tabs.all')})")
      end

      it 'selects the tab according to the filter' do
        visit cms_real_estates_path(:filter => RealEstate::STATE_PUBLISHED)
        page.should have_css("li.active:contains(#{I18n.t('cms.real_estates.index.tabs.published')})")
      end

      it 'shows the list of real estates for the current filter tab' do
        3.times{ Fabricate :real_estate, :category => @category, :state => RealEstate::STATE_PUBLISHED }
        visit cms_real_estates_path(:filter => RealEstate::STATE_PUBLISHED)
        page.should have_selector('table tr', :count => RealEstate.published.count + 1)
      end
    end

    it "shows the list of real estates" do
      page.should have_selector('table tr', :count => RealEstate.count+1)
    end

    it "shows the expected real estate attributes" do
      within("#real_estate_#{@real_estate.id}") do
        real_estate = RealEstateDecorator.decorate(@real_estate)

        page.should have_content real_estate.address.city
        page.should have_content real_estate.address.street
        page.should have_content real_estate.address.street_number
        page.should have_content real_estate.figure.shortened_floor
        page.should have_content real_estate.figure.surface
        page.should have_content real_estate.contact.fullname_reversed
        # real estate state-bar
        page.should have_css ('i.state.published.inactive')
        page.should have_css ('i.state.web.active')
        page.should have_css ('i.state.doc.inactive')
        page.should have_css ('i.state.portal.inactive')
        page.should have_css ('i.state.microsite.inactive')
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
          fill_in 'Projektwebseiten-Link', :with => 'http://www.google.ch'
          fill_in 'Titel', :with => 'My Real Estate'
          fill_in 'Beschreibung', :with => 'Some description...'
          fill_in 'Zusätzliche Objekt-Arten', :with => 'Gewerbe, Hotel'
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

        it 'saves the language' do
          select 'Italienisch', from: 'Anzeigensprache'
          click_on 'Immobilie erstellen'
          real_estate.language.should == 'it'
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

        it 'saves the project website link' do
          click_on 'Immobilie erstellen'
          real_estate.link_url.should == 'http://www.google.ch'
        end

        it 'enables it for the website' do
          check 'Website'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::WEBSITE_CHANNEL
        end

        it 'enables it for external real estate portal export' do
          check 'Dritt-Websites'
          fill_in 'Liegenschaftsreferenz', with: 'abc'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL
        end

        it 'enables it for the minidoku' do
          check 'Objektdokumentation'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::PRINT_CHANNEL
        end

        it 'enables it for micro-sites' do
          check 'MicroSite'
          select 'Gartenstadt-Schlieren'
          click_on 'Immobilie erstellen'
          real_estate.channels.should include RealEstate::MICROSITE_CHANNEL
        end

        it 'enables it for multiple channels' do
          check 'Website'
          check 'Dritt-Websites'
          fill_in 'Liegenschaftsreferenz', with: 'abc'
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
          fill_in 'Projektwebseiten-Link', :with => 'http://www.google.com'
          select 'Henker, Hanna', :from => 'Kontaktperson'

          fill_in 'Titel', :with => 'My edited Real Estate'
          fill_in 'Beschreibung', :with => 'Some edited description...'
          fill_in 'Zusätzliche Objekt-Arten', :with => 'Gewerbe, Hotel'
        end

        click_on 'Immobilie speichern'
      end

      it 'has updated the edited attributes' do
        @real_estate = RealEstate.find(@fabricated_real_estate.id)
        @real_estate.category.label.should == 'Child Category 2'
        @real_estate.utilization.should == Utilization::LIVING
        @real_estate.offer.should == Offer::RENT
        @real_estate.channels.should == %w(print)
        @real_estate.link_url.should == 'http://www.google.com'
        @real_estate.title.should == 'My edited Real Estate'
        @real_estate.contact.fullname.should == 'Hanna Henker'
        @real_estate.description.should == 'Some edited description...'
        @real_estate.utilization_description.should == 'Gewerbe, Hotel'
      end

      it 'has the Child Category 2 selected' do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
        find(:css, '#real_estate_category_id option[selected]').text.should == 'Child Category 2'
      end

      it 'has the contact Hanna Henker selected' do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
        find(:css, '#real_estate_contact_id option[selected]').text.should == 'Henker, Hanna'
      end

      it 'removes all channels when all channels are unchecked again' do
        visit edit_cms_real_estate_path(@fabricated_real_estate)

        within(".edit_real_estate") do
          uncheck 'Objektdokumentation'
          click_on 'Immobilie speichern'
        end

        @real_estate = RealEstate.find(@fabricated_real_estate.id)
        @real_estate.channels.should == []
      end
    end

    context 'when choosing microsite', :js => true do
      before do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
      end

      it 'shows the microsite select options immediately' do
        check 'MicroSite'
        page.should have_css('.microsite-options-container:not(.hidden)')
        page.should have_css('#real_estate_microsite_building_project', :count => 1)
      end

      it 'shows the microsite reference fields immediately' do
        page.should have_css('#real_estate_microsite_reference_property_key', :count => 1)
        page.should have_css('#real_estate_microsite_reference_building_key', :count => 1)
      end
    end

    context 'microsite was chosen' do
      before do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
      end
      
      describe '#update with valid microsite reference numbers' do
        before :each do
          within(".microsite_reference") do
            fill_in 'Hausnummer', :with => 'H'
            fill_in 'Immobiliennummer', :with => '22.34'
          end
          click_on 'Immobilie speichern'

          @fabricated_real_estate.reload
        end

        it 'stores the property_key' do
          @fabricated_real_estate.microsite_reference.property_key.should == '22.34'
        end

        it 'stores the building_key' do
          @fabricated_real_estate.microsite_reference.building_key.should == 'H'
        end
      end
    end

    context 'when the real estate is to be published to homegate', :js => true do
      before do
        visit edit_cms_real_estate_path(@fabricated_real_estate)
      end

      it 'shows the reference fields immediately' do
        check 'Dritt-Websites'
        page.should have_css('#real_estate_reference_property_key', :count => 1)
        page.should have_css('#real_estate_reference_building_key', :count => 1)
        page.should have_css('#real_estate_reference_unit_key', :count => 1)
      end

      describe '#update with invalid reference numbers' do
        before :each do
          check 'Dritt-Websites'
          fill_in 'Liegenschaftsreferenz', :with => ''
          fill_in 'Gebäudereferenz', :with => ''
          fill_in 'Objektreferenz', :with => ''
          click_on 'Immobilie speichern'
        end

        it 'requires at least one reference number' do
          page.should have_content 'Referenznummer muss ausgefüllt werden'
        end
      end

      describe '#update with already existing combination of reference numbers' do
        before :each do
          Fabricate(:real_estate,
                    channels: [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL],
                    reference: Reference.new( property_key: '123', building_key: '456', unit_key: '789'), 
                    category: Fabricate(:category))
        end

        it 'is not possible to save real estate' do
          check 'Dritt-Websites'
          fill_in 'Liegenschaftsreferenz', with: '123'
          fill_in 'Gebäudereferenz', with: '456'
          fill_in 'Objektreferenz', with: '789'
          click_on 'Immobilie speichern'

          page.should have_content 'Kombination der Referenznummern ist bereits vorhanden'
        end
      end
    end

    context 'selecting utilization' do
      context 'working', :js => true do
        context 'print channel is chosen' do
          it 'shows the print channel methods (options) immediately' do
            check 'Objektdokumentation'
            page.should have_css('.print-channel-methods-container:not(.hidden)')
            page.should have_css('.print-channel-method-container:not(.hidden)')
          end
        end

        context 'print channel is not chosen' do
          it 'does not show the print channel methods (options)' do
            page.should have_css('.print-channel-methods-container.hidden')
          end
        end
      end

      context 'living', :js => true do
        context 'print channel is chosen' do
          it 'shows the print channel methods immediately' do
            select 'Wohnen', :from => 'Gebäudenutzung'
            check 'Objektdokumentation'
            page.should have_css('.print-channel-methods-container:not(.hidden)')
            page.should have_css('.print-channel-method-container:not(.hidden)')
          end
        end

        context 'print channel is not chosen' do
          it 'does not show the print channel methods (options)' do
            select 'Wohnen', :from => 'Gebäudenutzung'
            page.should have_css('.print-channel-methods-container.hidden')
          end
        end
      end

      context 'parking', :js => true do
        context 'print channel is chosen' do
          it 'does not show the print channel methods (options) immediately' do
            select 'Parkieren', :from => 'Gebäudenutzung'
            check 'Objektdokumentation'
            page.should have_css('.print-channel-method-container.hidden')
          end
        end

        context 'print channel is not chosen' do
          it 'does not show the print channel methods (options)' do
            select 'Parkieren', :from => 'Gebäudenutzung'
            page.should have_css('.print-channel-methods-container.hidden')
          end
        end
      end

      context 'storing', :js => true do
        context 'print channel is chosen' do
          it 'does not show the print channel methods (options) immediately' do
            select 'Lagern', :from => 'Gebäudenutzung'
            check 'Objektdokumentation'
            page.should have_css('.print-channel-method-container.hidden')
          end
        end

        context 'print channel is not chosen' do
          it 'does not show the print channel methods (options)' do
            select 'Lagern', :from => 'Gebäudenutzung'
            page.should have_css('.print-channel-methods-container.hidden')
          end
        end
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
