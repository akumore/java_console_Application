# encoding: utf-8
require "spec_helper"

describe "Handout aka MiniDoku" do
  monkey_patch_default_url_options
  before { ApplicationController.new.set_current_view_context }

  let :information do
    Fabricate.build(:information,
                    :location_html => 'Lorem ipsum ... 2. Beschreibung',
                    :interior_html => 'Lorem ipsum ... 3. Beschreibung',
                    :infrastructure_html => 'Lorem ipsum ... 5. Beschreibung',
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

  let :figure do
    Fabricate.build(:figure,
                    :floor => 3,
                    :floor_estimate => '',
                    :rooms => '3.5',
                    :living_surface => 120,
                    :living_surface_estimate => '',
                    :specification_living_surface => 'Test one two three',
                    :property_surface => 100,
                    :storage_surface => 10,
                    :storage_surface_estimate => 20,
                    :usable_surface => 400,
                    :offer_html => 'Lorem ipsum ... 4. Beschreibung'
                  )
  end

  let :pricing do
    Fabricate.build(:pricing_for_rent,
                    :display_estimated_available_from => 'Mitte Mai',
                    :for_rent_netto => 1999,
                    :additional_costs => 99,
                    :price_unit => 'monthly')
  end

  let :printable_real_estate do
    Fabricate(:residential_building,
        :utilization => @utilization || Utilization::LIVING,
        :address => Fabricate.build(:address, :street => 'Musterstrasse', :street_number => '1', :zip => '8400', :city => 'Hausen'),
        :figure => figure,
        :pricing => pricing,
        :information => information,
        :title => 'Demo Objekt',
        :description => 'Lorem Ipsum',
        :floor_plans => [
          Fabricate.build(:media_assets_floor_plan)
        ]
      )
  end

  describe 'Title page' do
    it 'shows the real estate title' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Demo Objekt')
    end

    it 'shows the utilization of the real estate' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Mieten | Wohnen')
    end

    it 'shows the chapter title' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Objektübersicht')
    end

    it 'shows the address' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Musterstrasse 1, 8400 Hausen')
    end

    it 'shows the floor' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Geschoss')
      page.should have_content('3. Obergeschoss')
    end

    it 'shows the number of rooms' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('3.5 Zimmer')
    end


    describe "Usable surface" do
      it "shows the living surface if utilization is 'living'" do
        visit real_estate_handout_path(printable_real_estate)
        page.should have_content('Wohnfläche 120 m²')
      end

      it "shows the usable surface if utilization is 'working'" do
        @utilization = Utilization::WORKING
        visit real_estate_handout_path(printable_real_estate)
        page.should have_content('Nutzfläche 400 m²')
      end
    end

    it 'shows the description' do
      visit real_estate_handout_path(printable_real_estate)
      page.should have_content('Lorem Ipsum')
    end
  end

  describe 'Chapter Real Estate information' do
    describe 'General information' do

      it 'shows the chapter title' do
        visit real_estate_handout_path(printable_real_estate)
        page.should have_content('Weitere Informationen')
      end

      context 'real estate for living utilization' do
        before do
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'shows the floors' do
          page.should have_content('Geschosse')
          page.should have_content('20 Geschosse')
        end

        it 'shows renovated on' do
          page.should have_content('Letzte Renovierung')
          page.should have_content('1991')
        end

        it 'shows the built on' do
          page.should have_content('Baujahr')
          page.should have_content('2008')
        end

        it 'shows the floor' do
          page.should have_content('Geschoss')
          page.should have_content('3. Obergeschoss')
        end

        it 'shows the rooms' do
          page.should have_content('3.5 Zimmer')
        end

        it 'shows the surface' do
          page.should have_content('Wohnfläche')
          page.should have_content('120 m²')
        end
      end

      context 'real estate for working utilization' do
        before do
          @utilization = Utilization::WORKING
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'shows the floors' do
          page.should have_content('Geschosse')
          page.should have_content('20 Geschosse')
        end

        it 'shows renovated on' do
          page.should have_content('Letzte Renovierung')
          page.should have_content('1991')
        end

        it 'shos the built on' do
          page.should have_content('Baujahr')
          page.should have_content('2008')
        end

        it 'shows the property surface' do
          page.should have_content('Grundstückfläche')
          page.should have_content('100 m²')
        end

        it 'shows the storage surface' do
          page.should have_content('Lagerfläche')
          page.should have_content('20 m²')
        end

        it 'shows the cieling height' do
          page.should have_content('Raumhöhe')
          page.should have_content('5 m')
        end

        it 'shows the maximal floor loading' do
          page.should have_content('Maximale Bodenbelastung')
          page.should have_content('1234 kg')
        end

        it 'shows the freight elevator carrying capacity' do
          page.should have_content('Maximales Gewicht für Warenlift')
          page.should have_content('4321 kg')
        end

      end

      describe 'freight_elevator behaviour' do
        it 'shows freight_elevator label' do
          @utilization = Utilization::WORKING
          visit real_estate_handout_path(printable_real_estate)
          page.should have_content('Warenlift')
        end

        it "doesn't show freight_elevator label" do
          @utilization = Utilization::WORKING
          information.freight_elevator_carrying_capacity = ''
          visit real_estate_handout_path(printable_real_estate)
          page.should_not have_content('Warenlift')
        end
      end

      context 'real estate for storing utilization' do
        before do
          @utilization = Utilization::STORING
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'shows the floors' do
          page.should have_content('Geschosse')
          page.should have_content('20 Geschosse')
        end

        it 'shows renovated on' do
          page.should have_content('Letzte Renovierung')
          page.should have_content('1991')
        end

        it 'shos the built on' do
          page.should have_content('Baujahr')
          page.should have_content('2008')
        end

        it 'shows the ceiling height' do
          page.should have_content('Raumhöhe')
          page.should have_content('5 m')
        end

      end

      context 'real estate for parking utilization' do
        before do
          @utilization = Utilization::PARKING
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'does show the chapter title' do
          page.should have_content('Weitere Informationen')
        end
      end
    end

    describe 'specifications' do
      context 'with working utilization' do
        before do
          @utilization = Utilization::WORKING
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'shows the storage surface' do
          page.should have_content('Lagerfläche 20 m²')
        end

        context 'with toilet specification' do
          before do
            figure.update_attributes(:specification_usable_surface_toilet => true, :specification_usable_surface_with_toilet => 'Mit Toilette')
            visit real_estate_handout_path(printable_real_estate)
          end

          it 'shows the usable surface specification with toilet' do
            printable_real_estate.figure.specification_usable_surface_toilet?.should be_true
            page.should have_content('Mit Toilette')
          end
        end

        context 'without toilet specification' do
          before do
            figure.update_attributes(:specification_usable_surface_toilet => false, :specification_usable_surface_without_toilet => 'Ohne Toilette')
            visit real_estate_handout_path(printable_real_estate)
          end

          it 'shows the usable surface specification without toilet' do
            printable_real_estate.figure.specification_usable_surface_toilet?.should be_false
            page.should have_content('Ohne Toilette')
          end
        end
      end

      context 'with living utilization' do
        before do
          @utilization = Utilization::LIVING
          visit real_estate_handout_path(printable_real_estate)
        end

        it 'shows the storage surface' do
          page.should have_content('Lagerfläche 20 m²')
        end

        it 'shows the specification to living surface' do
          visit real_estate_handout_path(printable_real_estate)
          page.should have_content('Test one two three')
        end
      end

      context 'with storing utilization' do
        before do
          @utilization = Utilization::STORING
          visit real_estate_handout_path(printable_real_estate)
        end

        it "doesn't show the storage surface" do
          page.should_not have_content('Lagerfläche 20 m²')
        end

        it 'shows the specification to storing surface' do
          figure.update_attribute :specification_usable_surface, 'Spezifikation zur Lagerfläche'
          visit real_estate_handout_path(printable_real_estate)
          page.should have_content('Spezifikation zur Lagerfläche')
        end
      end

      context 'with parking utilization' do
        before do
          @utilization = Utilization::PARKING
          visit real_estate_handout_path(printable_real_estate)
        end

        it "doesn't show the storage surface" do
          page.should_not have_content('Lagerfläche 20 m²')
        end
      end
    end
  end

  describe 'Chapter Floorplan' do
    before do
      visit real_estate_handout_path(printable_real_estate)
    end

    it 'shows the chapter title' do
      page.should have_content('Grundriss')
    end

    it 'shows the floorplan' do
      page.should have_css(".floorplan-image > img", :count => 1)
    end

  end

  describe "Chapter Pricing" do

    shared_examples_for "Pricing information shown for all kind of real estates" do
      it "shows the rent price" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('pricings.for_rent_netto')
        page.should have_selector("span", :text => "1 999.00 CHF/Mt.")
      end

      it "shows 'without VAT message' if 'opted'" do
        @pricing.update_attribute :opted, true
        visit real_estate_handout_path(@real_estate)
        page.should have_content "Alle Preise ohne Mehrwertsteuer"
      end

      it "shows additional expenses" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('pricings.additional_costs')
        page.should have_selector("span", :text => "99.00 CHF/Mt.")
      end

      it "shows the price of the inside parking lot if available" do
        visit real_estate_handout_path(@real_estate)
        page.should_not have_content I18n.t('pricings.inside_parking')

        @pricing.update_attribute :inside_parking, 100
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz in Autoeinstellhalle'
        page.should have_selector("span", :text => "100.00 CHF/Mt.")
      end

      it "shows the price of the outside parking lot if available" do
        @pricing.update_attribute :outside_parking, 80
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz im Freien'
        page.should have_selector("span", :text => "80.00 CHF/Mt.")
      end

      it 'shows the real estate category in front of the sale price' do
        visit real_estate_handout_path(@real_estate)
        within '.chapter.pricing' do
          page.should have_content(@real_estate.category.label)
        end
      end

      context "for rent and with price unit 'year_m2'" do
        before :each do
          @real_estate.update_attribute(:offer, Offer::RENT)
          @pricing.update_attribute(:price_unit, 'year_m2')
          @pricing.update_attribute(:for_rent_netto_monthly, '50')
          @pricing.update_attribute(:additional_costs_monthly, '5')
          visit real_estate_handout_path(@real_estate)
        end

        it "shows the monthly prices for 'for_rent_netto_monthly'" do
          page.should have_selector("span", :text => "50.00 CHF/Mt.")
        end

        it "shows the monthly prices for 'additional_costs_monthly'" do
          page.should have_selector("span", :text => "5.00 CHF/Mt.")
        end

        context 'when estimate field is present' do
          before :each do
            @real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
            visit real_estate_handout_path(@real_estate)
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
            @real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis')
            @real_estate.pricing.update_attribute(:estimate, 'Ungefährer Preis monatlich')
            visit real_estate_handout_path(@real_estate)
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


    context "Real Estate, living, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :additional_costs => 99, :price_unit => 'monthly'
        @real_estate = Fabricate :residential_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

    end


    context "Real Estate, working, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :additional_costs => 99, :price_unit => 'monthly', :opted => false
        @real_estate = Fabricate :commercial_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

    end
  end

  describe "Chapter Information" do

    context 'real estate for living utilization' do
      before do
        visit real_estate_handout_path printable_real_estate
      end

      it 'shows the chapter title' do
        page.should have_content 'Weitere Informationen'
      end

      it 'shows the availability date' do
        page.should have_content 'Bezug'
        page.should have_content 'Mitte Mai'
      end

      it "doesn't show if it is a new building" do
        page.should_not have_content 'Neubau'
      end

      it "doesn't show if it is an old building" do
        page.should_not have_content 'Altbau'
      end

      it 'shows the minergie infos' do
        page.should have_content 'Minergie Bauweise'
        page.should have_content 'Minergie zertifiziert'
      end

      it 'shows if it is under building laws' do
        pending 'figure out what this is supposed to do'
      end

      it "has no view" do
        page.should have_content 'Ausblick'
      end

      it 'has fireplace' do
        page.should have_content 'Cheminée'
      end

      it 'has an elevator' do
        page.should have_content 'Liftzugang'
      end

      it 'has isdn connectivity' do
        page.should have_content 'ISDN Anschluss'
      end

      it 'is wheelchair accessible' do
        page.should have_content 'rollstuhltauglich'
      end

      it 'is child friendly' do
        page.should have_content 'kinderfreundlich'
      end

      it 'has a balcony' do
        page.should have_content 'Balkon'
      end

      it "doesn't have a raised groundfloor" do
        page.should_not have_content 'Hochparterre'
      end

      it 'has a garden seating' do
        page.should have_content 'Gartensitzplatz'
      end

      it 'has a swimmingpool' do
        page.should have_content 'Schwimmbecken'
      end

      it 'does not show the ceiling height' do
        page.should_not have_content 'Raumhöhe'
      end
    end

    context 'real estate for working utilization' do
      before do
        @utilization = Utilization::WORKING
        visit real_estate_handout_path printable_real_estate
      end

      it 'has max floor loading' do
        page.should have_content 'Maximale Bodenbelastung'
        page.should have_content "1234 kg"
      end

      it 'has max elevator carrying capacity' do
        page.should have_content 'Maximales Gewicht für Warenlift'
        page.should have_content "4321 kg"
      end

      it 'has the number of restrooms' do
        page.should have_content '3 WC'
      end

      it 'has a lifting platform' do
        page.should have_content 'Hebebühne'
      end

      it 'has a ramp' do
        page.should have_content 'Anfahrrampe'
      end

      it 'has a railway terminal' do
        page.should have_content 'Bahnanschluss'
      end

      it 'has water supply' do
        page.should have_content 'Wasseranschluss'
      end

      it 'has sewage supply' do
        page.should have_content 'Abwasseranschluss'
      end

      it 'shows the ceiling height' do
        page.should have_content 'Raumhöhe'
      end
    end

    context 'real estate for storing utilization' do
      before do
        @utilization = Utilization::STORING
        visit real_estate_handout_path printable_real_estate
      end

      it 'shows the ceiling height' do
        page.should have_content 'Raumhöhe'
      end
    end
  end

  # TODO: noelle, make new specs that make sense when content structure in handout is updated (Feature 24/21)
  # describe "Chapter Descriptions" do
  #   before do
  #     visit real_estate_handout_path(printable_real_estate)
  #   end

  #   it 'shows the chapter title' do
  #     within('.chapter.additional-description h2') do
  #       page.should have_content 'Beschreibung'
  #     end
  #   end

  #   it 'shows the location description' do
  #     page.should have_content 'In der Nähe'
  #     page.should have_content 'Lorem ipsum ... 2. Beschreibung'
  #   end

  #   it 'shows the interior description' do
  #     page.should have_content 'Ausbaustandard'
  #     page.should have_content 'Lorem ipsum ... 3. Beschreibung'
  #   end

  #   it 'shows the offer description' do
  #     page.should have_content 'Angebot'
  #     page.should have_content 'Lorem ipsum ... 4. Beschreibung'
  #   end

  #   it 'shows the infrastructure description' do
  #     page.should have_content 'Infrastruktur'
  #     page.should have_content 'Lorem ipsum ... 5. Beschreibung'
  #   end

  #   it 'shows the usage description' do
  #     page.should have_content 'Nutzung'
  #     page.should have_content "#{printable_real_estate.category.label}/Commercial/Restaurant"
  #   end
  # end

  describe "Chapter Contact" do

    before do
      @contact_person = Fabricate :employee
      @real_estate = Fabricate :residential_building,
                               :contact => @contact_person,
                               :pricing => Fabricate.build(:pricing_for_rent),
                               :link_url => 'www.gartenstadt.ch'
    end

    it "is not available, if contact person is't assigned to real estate" do
      real_estate = Fabricate :residential_building, :pricing=>Fabricate.build(:pricing_for_rent)
      visit real_estate_handout_path(real_estate)

      page.should_not have_css ".chapter.contact"
    end

    it 'shows the employees name' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content "#{@contact_person.firstname} #{@contact_person.lastname}"
      end
    end

    it 'shows the employees function' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content @contact_person.job_function
      end
    end

    it 'shows the employees address' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content "Neuhofstrasse 10"
        page.should have_content "CH-6340 Baar"
      end
    end

    it 'shows the employees phone numbers' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content @contact_person.phone
      end
    end

    it 'shows the employees email address' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content @contact_person.email
      end
    end

    it 'shows the homepage address' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content 'www.alfred-mueller.ch'
      end
    end

    it 'shows the link from the address record if present' do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content 'www.gartenstadt.ch'
      end
    end
  end

  describe "Chapter Pictures" do
    before do
      @primary_image = Fabricate.build :media_assets_image, :is_primary=>true, :title=>"The primary image"
      @ground_plot = Fabricate.build :media_assets_floor_plan, :title=>"The beautiful floor plan"
      @kitchen = Fabricate.build(:media_assets_image, :title=>"The kitchen")
      @bathroom = Fabricate.build(:media_assets_image, :title=>"The bathroom")

      @real_estate = RealEstateDecorator.decorate Fabricate :residential_building,
                                :contact=>@contact_person, :pricing => Fabricate.build(:pricing_for_rent),
                                :images => [@primary_image, @kitchen, @bathroom], :floor_plans => [@ground_plot]
    end

    it "shows the chapter title" do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.images h2" do
        page.should have_content "Bilder"
      end
    end

    it "doesn't show the main-picture" do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.images" do
        page.should_not have_content @primary_image.title
        page.should_not have_css "#image-#{@primary_image.id}"
      end
    end

    it "doesn't show the ground plot" do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.images" do
        page.should_not have_content @ground_plot.title
        page.should_not have_css "#image-#{@ground_plot.id}"
      end
    end

    context "All other pictures" do
      it "shows all other pictures" do
        visit real_estate_handout_path(@real_estate)
        within ".chapter.images" do
          [@kitchen, @bathroom].each { |img| page.should have_css "#image-#{img.id}" }
        end
      end

      it "shows the first one enlarged" do
        visit real_estate_handout_path(@real_estate)
        page.should have_css ".chapter.images div.enlarged-image#image-#{@kitchen.id}"
      end

      it "uses a two-column layout for rendering others" do
        visit real_estate_handout_path(@real_estate)
        page.should have_css ".chapter.images div.smaller-images #image-#{@bathroom.id}"
      end
    end

    it "shows the title of the pictures" do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.images" do
        [@bathroom, @kitchen].each { |image| page.should have_content image.title }
      end
    end

  end

  describe 'Routing' do
    context 'with an old URL containing the real estate title' do
      it 'redirects to the handout pdf to prevent mass cachefile generation' do
        PDFKit.stub!(:new).and_return mock(PDFKit, :to_pdf => 'stuff')
        visit real_estate_object_documentation_path(
          :real_estate_id => printable_real_estate,
          :name => printable_real_estate.handout.filename,
          :locale => :de,
          :format => :pdf
        )
        current_path.should == real_estate_handout_path(
          :real_estate_id => printable_real_estate,
          :locale => :de,
          :format => :pdf
        )
      end
    end
  end
end
