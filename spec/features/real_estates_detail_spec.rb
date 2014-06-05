# encoding: utf-8

require "spec_helper"

describe "RealEstates" do
  monkey_patch_default_url_options
  before { ApplicationController.new.set_current_view_context }
  before { @utilization = Utilization::LIVING }

  let :category do
    Fabricate(:category, :label => 'Wohnung')
  end

  let :real_estate do
    Fabricate :published_real_estate,
      :utilization => @utilization,
      :category => category,
      :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
      :address => Fabricate.build(:address),
      :information => @information || Fabricate.build(:information),
      :figure => @figure || Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
      :pricing => Fabricate.build(:pricing),
      :contact => Fabricate(:employee),
      :link_url => 'http://www.alfred-mueller.ch'
  end

  let :unpublished_real_estate do
    Fabricate :real_estate,
      :category => category,
      :address => Fabricate.build(:address),
      :figure => Fabricate.build(:figure, :rooms => 20, :floor => 1),
      :pricing => Fabricate.build(:pricing),
      :contact => Fabricate(:employee)
  end

  describe "Visiting unpublished real estate" do
    it "redirects to real estate index page" do
      visit real_estate_path(unpublished_real_estate)
      current_path.should == real_estates_path
    end
  end

  describe "Visiting web channel disabled real estate" do
    it 'redirects to real estate index page' do
      real_estate.update_attribute :channels, []
      visit real_estate_path(real_estate)
      current_path.should == real_estates_path
    end
  end

  describe 'Visit real estate show path', :show => true do

    describe 'Chapter Information' do
      context 'living' do
        before do @utilization = Utilization::LIVING end

        it 'renders the page correct' do
          visit real_estate_path(real_estate)
          page.should have_css("meta[content='#{RealEstateDecorator.new(real_estate).seo_description}']")

          page.should have_css('div.detail')
          page.should have_css("div.real-estate-#{real_estate.id}")

          page.should have_content(real_estate.title)

          page.within('.short-info') do
            address = real_estate.address
            page.should have_content "#{address.city} #{address.canton.upcase}"
            page.should have_content "#{address.street} #{address.street_number}"
            page.should have_content(RealEstateDecorator.new(real_estate).utilization_description)
            page.should have_content "#{real_estate.figure.rooms} Zimmer"
            page.should have_content "#{real_estate.figure.floor}. Obergeschoss"
            page.should have_content real_estate.figure.living_surface
          end

          page.should have_content(real_estate.description)
          page.should have_css('h3:contains(Standort)')
          page.html.gsub(/\s*/m, ' ').should include real_estate.information.location_html.gsub(/\s*/m, ' ')
          page.should have_css('h3:contains(Ausbaustandard)')
          page.html.gsub(/\s*/m, ' ').should include real_estate.information.interior_html.gsub(/\s*/m, ' ')
          page.should have_css('h3:contains(Angebot)')
          page.html.gsub(/\s*/m, ' ').should include real_estate.figure.offer_html.to_s.gsub(/\s*/m, ' ')
          page.should have_css('h3:contains(Infrastruktur)')
          page.html.gsub(/\s*/m, ' ').should include real_estate.information.infrastructure_html.gsub(/\s*/m, ' ')
          page.should_not have_content('Raumhöhe')
        end
      end

      context 'working' do
        before do @utilization = Utilization::WORKING end

        it 'renders the page correct' do
          visit real_estate_path(real_estate)
          page.should have_content('Raumhöhe')
        end

      end

      context 'storing' do
        before do @utilization = Utilization::WORKING end

        it 'renders the page correct' do
          visit real_estate_path(real_estate)
          page.should have_content('Raumhöhe')
        end
      end

      describe 'Chapter Pricing' do
        context 'when the real estate is for rent' do
          before :each do
            real_estate.update_attribute :offer, Offer::RENT
            real_estate.update_attribute :channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
            visit real_estate_path(real_estate)
          end

          it 'shows the real estate category in front of the sale price' do
            within '.description' do
              page.should have_content(real_estate.category.label)
            end
          end

          it "shows the localized price for rent" do
            page.should have_selector("span", :text => "1 520.00 CHF/Mt.")
          end

          it "shows the additional costs" do
            page.should have_content("Nebenkosten")
            page.should have_selector("span", :text => "100.00 CHF/Mt.")
          end

          context 'when additional costs is set to 0' do
            before do
              real_estate.pricing.update_attribute(:additional_costs, 0)
              visit real_estate_path(real_estate)
            end

            it "doesn't show the additional costs" do
              expect(page).not_to have_selector("span.additional_costs")
            end

            it "shows the included additional costs in the category label" do
              expect(page).to have_content("#{real_estate.category.label} (inklusive Nebenkosten)")
            end
          end

          context 'when estimate field is present' do
            before :each do
              real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
              visit real_estate_path(real_estate)
            end

            it 'shows the estimate field' do
              page.should have_selector("span", :text => "Ungefährer Preis")
            end
          end

          describe '#opted' do
            context 'when opted is true' do
              before :each do
                real_estate.pricing.update_attribute(:opted, true)
                visit real_estate_path(real_estate)
              end

              it "shows VAT message" do
                page.should have_content "Alle Preise ohne Mehrwertsteuer"
              end
            end

            context 'when opted is false' do
              before :each do
                real_estate.pricing.update_attribute(:opted, false)
                visit real_estate_path(real_estate)
              end

              it "does not show VAT message" do
                page.should_not have_content "Alle Preise ohne Mehrwertsteuer"
              end
            end
          end
        end

        context 'when the real estate is for sale' do
          before :each do
            real_estate.update_attribute :offer, Offer::SALE
            visit real_estate_path(real_estate)
          end

          it 'shows the real estate category in front of the sale price' do
            within '.description' do
              page.should have_content(real_estate.category.label)
            end
          end

          it "shows the localized price for sale" do
            page.should have_selector("span", :text => "1.3 Mio. CHF")
          end

          it "shows the additional costs" do
            page.should have_content("Nebenkosten")
            page.should have_selector("span", :text => "100.00 CHF/Mt.")
          end

          context 'when estimate field is present' do
            before :each do
              real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
              visit real_estate_path(real_estate)
            end

            it 'shows the estimate field' do
              page.should have_selector("span", :text => "Ungefährer Preis")
            end
          end

          describe '#opted' do
            context 'when opted is true' do
              before :each do
                real_estate.pricing.update_attribute(:opted, true)
                visit real_estate_path(real_estate)
              end

              it "shows VAT message" do
                page.should have_content "Alle Preise ohne Mehrwertsteuer"
              end
            end

            context 'when opted is false' do
              before :each do
                real_estate.pricing.update_attribute(:opted, false)
                visit real_estate_path(real_estate)
              end

              it "does not show VAT message" do
                page.should_not have_content "Alle Preise ohne Mehrwertsteuer"
              end
            end
          end
        end

        context "for rent and with price unit 'year_m2'" do
          before :each do
            real_estate.update_attribute(:offer, Offer::RENT)
            real_estate.pricing.update_attribute(:price_unit, 'year_m2')
            real_estate.pricing.update_attribute(:for_rent_netto_monthly, '50')
            real_estate.pricing.update_attribute(:additional_costs_monthly, '5')
            visit real_estate_path(real_estate)
          end

          it "shows the monthly prices for 'for_rent_netto_monthly'" do
            page.should have_selector("span", :text => "50.00")
          end

          it "shows the monthly prices for 'additional_costs_monthly'" do
            page.should have_selector("span", :text => "5.00 CHF/Mt.")
          end

          context 'when estimate field is present' do
            before :each do
              real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
              visit real_estate_path(real_estate)
            end

            it 'shows estimate field' do
              page.should have_selector("span", :text => "Ungefährer Preis")
            end

            it 'shows for_rent_netto_monthly pricing field' do
              page.should have_selector("span", :text => "50.00 CHF/Mt.")
            end
          end

          context 'when estimate and estimate_monthly field is present' do
            before :each do
              real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
              real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis monatlich')
              visit real_estate_path(real_estate)
            end

            it 'shows estimate field' do
              page.should have_selector("span", :text => "Ungefährer Preis")
            end

            it 'shows estimate_monthly field' do
              page.should have_selector("span", :text => "Ungefährer Preis monatlich")
            end
          end
        end
      end

      describe "Chapter Information" do
        let :figure do
          Fabricate.build(:figure,
                          :floor => 3,
                          :floor_estimate => '',
                          :rooms => '3.5',
                          :living_surface => 120,
                          :living_surface_estimate => '',
                          :specification_living_surface => 'Test one two three',
                          :property_surface => 100,
                          :storage_surface => 10
                         )
        end

        let :information do
          Fabricate.build(:information,
                          :display_estimated_available_from => 'Mitte Mai',
                          :is_new_building => true,
                          :is_old_building => true,
                          :is_minergie_style => true,
                          :is_minergie_certified => true,
                          :has_outlook => true,
                          :has_fireplace => true,
                          :has_isdn => true,
                          :has_elevator => true,
                          :is_wheelchair_accessible => true,
                          :is_child_friendly => true,
                          :has_balcony => true,
                          :has_garden_seating => true,
                          :has_raised_ground_floor => true,
                          :has_swimming_pool => true,
                          :has_ramp => true,
                          :maximal_floor_loading => 1234,
                          :freight_elevator_carrying_capacity => 4321,
                          :has_lifting_platform => true,
                          :has_railway_terminal => true,
                          :has_water_supply => true,
                          :has_sewage_supply => true,
                          :number_of_restrooms => 3,
                          :floors => 20,
                          :renovated_on => '1991',
                          :built_on => '2008',
                          :ceiling_height => 5
                         )
        end

        before do
          @figure = figure
          @information = information
        end

        it 'shows the chapter title' do
          visit real_estate_path(real_estate)
          page.should have_content('Immobilieninfos')
        end

        context 'real estate for living utilization' do
          before do visit real_estate_path(real_estate) end

          it 'renders page correct' do
            page.should have_content('Geschosse')
            page.should have_content('20 Geschosse')
            page.should have_content('Letzte Renovierung')
            page.should have_content('1991')
            page.should have_content('Baujahr')
            page.should have_content('2008')
            page.should have_content('Geschoss')
            page.should have_content('3. Obergeschoss')
            page.should have_content('Zimmeranzahl')
            page.should have_content('3.5 Zimmer')
            page.should have_content('Wohnfläche')
            page.should have_content('120 m²')
            expect(page).to have_content('Gartensitzplatz')
          end
        end

        context 'real estate for working utilization' do
          before do
            @utilization = Utilization::WORKING
            visit real_estate_path(real_estate)
          end

          it 'shows the floors' do
            page.should have_content('Geschosse')
            page.should have_content('20 Geschosse')
            page.should have_content('Letzte Renovierung')
            page.should have_content('1991')
            page.should have_content('Baujahr')
            page.should have_content('2008')
            page.should have_content('Grundstückfläche')
            page.should have_content('100 m²')
            page.should have_content('Lagerfläche')
            page.should have_content('10 m²')
            page.should have_content('Raumhöhe')
            page.should have_content('5 m')
            page.should have_content('Maximale Bodenbelastung')
            page.should have_content('1234 kg')
            page.should have_content('Maximales Gewicht für Warenlift')
            page.should have_content('4321 kg')
          end
        end

        context 'real estate for storing utilization' do
          before do
            @utilization = Utilization::STORING
            visit real_estate_path(real_estate)
          end

          it 'shows the floors' do
            page.should have_content('Geschosse')
            page.should have_content('20 Geschosse')
            page.should have_content('Letzte Renovierung')
            page.should have_content('1991')
            page.should have_content('Baujahr')
            page.should have_content('2008')
            page.should have_content('Raumhöhe')
            page.should have_content('5 m')
          end
        end

        context 'real estate for parking utilization' do
          before do
            @utilization = Utilization::PARKING
            visit real_estate_path(real_estate)
          end

          it 'does not show the chapter title' do
            page.should_not have_content('Immobilieninfos')
          end
        end
      end

      describe 'contact' do
        it 'displays the full name of the responsible person' do
          visit real_estate_path(real_estate)
          page.should have_content(real_estate.contact.fullname)
          page.should have_content(real_estate.contact.phone)
          page.should have_content(real_estate.contact.fax)
          page.should have_content(real_estate.contact.mobile)
          page.should have_link('E-Mail')
        end
      end
    end

    describe 'Chapter Information' do
      context 'with living utilization' do
        before :each do
          @utilization = Utilization::LIVING
          visit real_estate_path(real_estate)
        end

        it 'shows the additional information text' do
          page.should have_content('Ergänzende Informationen zum Ausbau')
        end
      end

      context 'with working utilization' do
        before :each do
          @utilization = Utilization::WORKING
          visit real_estate_path(real_estate)
        end

        it 'shows the additional information text' do
          page.should have_content('Ergänzende Informationen zum Ausbau')
        end
      end

      context 'with storing utilization' do
        before :each do
          @utilization = Utilization::STORING
          visit real_estate_path(real_estate)
        end

        it 'shows the additional information text' do
          page.should have_content('Ergänzende Informationen zum Ausbau')
        end
      end

      context 'with parking utilization' do
        before :each do
          @utilization = Utilization::PARKING
          visit real_estate_path(real_estate)
        end

        it "doesn't show the additional information text" do
          page.should_not have_content('Ergänzende Informationen zum Ausbau')
        end
      end
    end

    describe 'sidebar' do
      it 'shows the project website link' do
        visit real_estate_path(real_estate)

        page.within('.sidebar') do
          page.should have_link 'Zur Projektwebseite', :href => real_estate.link_url
        end
      end

      context 'when the real estate is for rent' do
        context 'and for working' do
          context 'when order was chosen for print channel method' do
            before :each do
              real_estate.update_attribute(:utilization, Utilization::WORKING)
              real_estate.update_attribute(:offer, Offer::RENT)
              real_estate.update_attribute(:channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL])
              real_estate.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_ORDER)
              visit real_estate_path(real_estate)
            end

            it 'has a handout order link' do
              page.within('.sidebar') do
                page.should have_link('Objektdokumentation bestellen')
              end
            end

            it 'has no link to the mini doku' do
              page.within('.sidebar') do
                page.should_not have_link('Objektdokumentation', :href => real_estate_handout_path(
                  :real_estate_id => real_estate.id,
                  :format => :pdf
                ))
              end
            end
          end

          context 'when pdf download was chosen for print channel method' do
            it 'has a link to the mini doku' do
              real_estate.update_attribute :offer, Offer::RENT
              real_estate.update_attribute :channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
              visit real_estate_path(real_estate)
              page.within('.sidebar') do
                page.should have_link('Objektdokumentation', :href => real_estate_handout_path(
                  :real_estate_id => real_estate.id,
                  :format => :pdf
                ))
              end
            end
          end
        end

        context 'and for living' do
          context 'when order was chosen for print channel method' do
            before :each do
              real_estate.update_attribute(:utilization, Utilization::LIVING)
              real_estate.update_attribute(:offer, Offer::RENT)
              real_estate.update_attribute(:channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL])
              real_estate.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_ORDER)
              visit real_estate_path(real_estate)
            end

            it 'has a handout order link' do
              page.within('.sidebar') do
                page.should have_link('Objektdokumentation bestellen')
              end
            end

            it 'has no link to the mini doku' do
              page.within('.sidebar') do
                page.should_not have_link('Objektdokumentation', :href => real_estate_handout_path(
                  :real_estate_id => real_estate.id,
                  :format => :pdf
                ))
              end
            end
          end

          context 'when pdf download was chosen for print channel method' do
            it 'has a link to the mini doku' do
              real_estate.update_attribute :offer, Offer::RENT
              real_estate.update_attribute :channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
              visit real_estate_path(real_estate)
              page.within('.sidebar') do
                page.should have_link('Objektdokumentation', :href => real_estate_handout_path(
                  :real_estate_id => real_estate.id,
                  :format => :pdf
                ))
              end
            end
          end
        end

        context 'for parking' do
          it "doesn't have a link to the mini doku" do
            real_estate.update_attribute :utilization, Utilization::PARKING
            visit real_estate_path(real_estate)
            page.within('.sidebar') do
              page.should_not have_link('Objektdokumentation')
            end
          end
        end

        context 'for living' do
          before do
            real_estate.update_attribute :utilization, Utilization::LIVING
          end

          context 'show_application_form flag is set' do
            it 'has a link for the application form pdf' do
              real_estate.update_attribute :show_application_form, true
              visit real_estate_path(real_estate)
              page.within('.sidebar') do
                page.should have_link('Anmeldeformular', :href => '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf')
              end
            end
          end

          context 'show_application_form flag is not set' do
            it 'has no link for the application form pdf' do
              real_estate.update_attribute :show_application_form, false
              visit real_estate_path(real_estate)
              page.within('.sidebar') do
                page.should_not have_link('Anmeldeformular', :href => '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf')
              end
            end
          end
        end

        context 'for working' do
          it 'has a link for the application form pdf' do
            real_estate.update_attribute :utilization, Utilization::WORKING
            visit real_estate_path(real_estate)
            page.within('.sidebar') do
              page.should have_link('Anmeldeformular', :href => '/documents/de/Anmeldeformular-Mieten-Gewerbe.pdf')
            end
          end
        end
      end

      context 'when the real estate is for sale' do
        it 'has no link to the mini doku' do
          real_estate.update_attribute :offer, Offer::SALE
          visit real_estate_path(real_estate)
          page.within('.sidebar') do
            page.should_not have_link('Objektbeschrieb')
          end
        end
      end
    end

    it "has a map of the real estate location" do
      visit real_estate_path(real_estate)
      page.should have_css(".map", :count => 1)
    end

    it "has the json representation of the location" do
      visit real_estate_path(real_estate)
      find(".map[data-real_estate]")['data-real_estate'].should == real_estate.to_json(:only => :_id, :methods => :coordinates)
    end

    context 'having a floorplan', :fp => true do
      before :each do
        @real_estate_with_floorplan = real_estate
        @real_estate_with_floorplan.floor_plans << Fabricate.build(:media_assets_floor_plan)
        visit real_estate_path(@real_estate_with_floorplan)
      end

      it 'shows the floorplan link' do
        page.should have_link('Grundriss anzeigen')
      end

      it 'shows the floorplan print link' do
        page.should have_link('Grundriss drucken', :href => real_estate_floorplans_path(real_estate, :print => true))
      end

      it 'shows the floorplan slide with a zoom button' do
        page.should have_css('.flexslider .slides li .zoom-floorplan')
      end

      it 'zooms the floorplan in an overlay', :js => true do
        # Modernizr.touch by defaults is set to true for capybara webkit env
        # Workaround: Set flag to false, then re-initialize Application
        page.execute_script("Modernizr.touch = false;new AlfredMueller.Routers.Application();")
        first('.flexslider .slides li .zoom-floorplan').click
        page.should have_css(".fancybox-opened img[src='#{@real_estate_with_floorplan.floor_plans.first.file.gallery_zoom.url}']")
      end
    end

    context 'not having a floorplan', :js => true, :fp => true do
      it 'does not show the floorplan link' do
        page.should_not have_link('Grundriss anzeigen')
      end
    end

    context 'Making an appointment', :appointment => true do
      it 'integrates appointment slide into slide show' do
        visit real_estate_path(real_estate)
        page.should have_css ".appointment"
      end

      it "renders no appointment slide if contact isn't assigned to real estate" do
        real_estate.contact.destroy
        visit real_estate_path(real_estate)
        page.should_not have_css ".appointment"
      end

      it 'renders the appointment form download link' do
        visit real_estate_path(real_estate)
        page.within('.sidebar') do
          page.should have_link('Anmeldeformular', :href => '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf')
        end
      end

      it "sends an appointment mail upon submitting the form" do
        visit real_estate_path(real_estate)
        within(".appointment") do
          fill_in 'appointment_firstname', :with => 'Hans'
          fill_in 'appointment_lastname', :with => 'Muster'
          fill_in 'appointment_email', :with => 'hans.muster@test.ch'
          fill_in 'appointment_phone', :with => '123 456 66 44'
          fill_in 'appointment_street', :with => 'musterstrasse'
          fill_in 'appointment_zipcode', :with => '8234'
          fill_in 'appointment_city', :with => 'the citey'
        end

        lambda {
          click_on 'Kontaktieren Sie mich'
        }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end

    context 'Making a handout order' do
      before :each do
        real_estate.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_ORDER)
      end

      it 'integrates handout order slide into slide show' do
        visit real_estate_path(real_estate)
        page.should have_css ".handout-order"
      end

      it "sends an appointment mail upon submitting the form" do
        visit real_estate_path(real_estate)
        within(".handout-order") do
          fill_in 'handout_order_firstname', :with => 'Musterunternehmen'
          fill_in 'handout_order_firstname', :with => 'Hans'
          fill_in 'handout_order_lastname', :with => 'Muster'
          fill_in 'handout_order_email', :with => 'hans.muster@test.ch'
          fill_in 'handout_order_phone', :with => '123 456 66 44'
          fill_in 'handout_order_street', :with => 'musterstrasse'
          fill_in 'handout_order_zipcode', :with => '8234'
          fill_in 'handout_order_city', :with => 'the citey'
        end

        lambda {
          click_on 'Bestellung abschicken'
        }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end

  describe RealEstatePagination do
    before do
      real_estate.reload
    end

    context 'with one real estate' do
      before do
        visit real_estate_path(real_estate)
      end

      it 'does not show a link to the next or previous search result' do
        page.should_not have_link('Nächstes Projekt')
        page.should_not have_link('Vorheriges Projekt')
      end
    end

    context 'with two real estates' do
      before do
        Fabricate :published_real_estate,
          :category => category,
          :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
          :address => Fabricate.build(:address),
          :information => Fabricate.build(:information),
          :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
          :pricing => Fabricate.build(:pricing),
          :contact => Fabricate(:employee)

        visit real_estate_path(real_estate)
      end

      it 'shows only the link to the next search result' do
        page.should have_link('Nächstes Projekt')
        page.should_not have_link('Vorheriges Projekt')
      end
    end

    context 'with three or more real estates' do
      before do
        2.times do
          Fabricate :published_real_estate,
            :category => category,
            :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
            :address => Fabricate.build(:address),
            :information => Fabricate.build(:information),
            :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
            :pricing => Fabricate.build(:pricing),
            :contact => Fabricate(:employee)
        end

        visit real_estate_path(real_estate)
      end

      it 'shows link to the next and previous search result' do
        click_link 'Nächstes Projekt'
        page.should have_link('Nächstes Projekt')
        page.should have_link('Vorheriges Projekt')
      end
    end
  end

  describe "search filter" do
    context 'for a private for sale real estate' do
      let :search_filter_real_estate do
        Fabricate :published_real_estate,
          :utilization => Utilization::LIVING,
          :offer => Offer::SALE,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :figure => Fabricate.build(:figure),
          :pricing => Fabricate.build(:pricing_for_sale)
      end

      before do
        visit real_estate_path search_filter_real_estate
      end

      it 'renders the sale tab active' do
        page.should have_css('.offer-tabs .for_sale-tab.selected')
      end

      it 'renders the private tab active' do
        page.should have_css('.utilization-tabs .living.selected')
      end
    end

    context 'for a commercial for sale real estate' do
      let :search_filter_real_estate do
        Fabricate :published_real_estate,
          :utilization => Utilization::WORKING,
          :offer => Offer::SALE,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :figure => Fabricate.build(:figure),
          :pricing => Fabricate.build(:pricing_for_sale)
      end

      before do
        visit real_estate_path search_filter_real_estate
      end

      it 'renders the sale tab active' do
        page.should have_css('.offer-tabs .for_sale-tab.selected')
      end

      it 'renders the commercial tab active' do
        page.should have_css('.utilization-tabs .working.selected')
      end
    end

    context 'for a private for rent real estate' do
      let :search_filter_real_estate do
        Fabricate :published_real_estate,
          :utilization => Utilization::LIVING,
          :offer => Offer::RENT,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :figure => Fabricate.build(:figure),
          :pricing => Fabricate.build(:pricing_for_rent)
      end

      before do
        visit real_estate_path search_filter_real_estate
      end

      it 'renders the rent tab active' do
        page.should have_css('.offer-tabs .for-rent-tab.selected')
      end

      it 'renders the private tab active' do
        page.should have_css('.utilization-tabs .living.selected')
      end
    end

    context 'for a commercial for rent real estate' do
      let :search_filter_real_estate do
        Fabricate :published_real_estate,
          :utilization => Utilization::WORKING,
          :offer => Offer::RENT,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :figure => Fabricate.build(:figure),
          :pricing => Fabricate.build(:pricing_for_rent)
      end

      before do
        visit real_estate_path search_filter_real_estate
      end

      it 'renders the rent tab active' do
        page.should have_css('.offer-tabs .for-rent-tab.selected')
      end

      it 'renders the commercial tab active' do
        page.should have_css('.utilization-tabs .working.selected')
      end
    end
  end

end
