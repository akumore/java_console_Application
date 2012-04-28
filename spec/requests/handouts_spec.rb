# encoding: utf-8
require "spec_helper"

describe "Handout aka MiniDoku" do
  monkey_patch_default_url_options

  let :printable_real_estate do
    Fabricate(:residential_building,
        :address => Fabricate.build(:address, :street => 'Musterstrasse', :street_number => '1', :zip => '8400', :city => 'Hausen'),
        :figure => Fabricate.build(:figure, :floor => 3, :floor_estimate => '', :rooms => '3.5', :living_surface => 120, :living_surface_estimate => ''),
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :price_unit => 'monthly'),
        :information => Fabricate.build(:information,
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
          :minimum_rental_period => '1 Jahr',
          :notice_dates => 'September, März',
          :notice_period => '3 Monate'
        ),
        :title => 'Demo Objekt',
        :description => 'Lorem Ipsum',
        :property_name => 'Gartenstadt',
        :media_assets => [
          Fabricate.build(:media_asset_floorplan)
        ],
        :additional_description => Fabricate.build(:additional_description,
          :location => 'Lorem ipsum ... 2. Beschreibung',
          :interior => 'Lorem ipsum ... 3. Beschreibung',
          :offer => 'Lorem ipsum ... 4. Beschreibung',
          :infrastructure => 'Lorem ipsum ... 5. Beschreibung'
        )
      )
  end

  describe 'Title page' do
    before do
      visit real_estate_handout_path(printable_real_estate)
    end

    it 'shows the real estate title' do
      page.should have_content('Demo Objekt')
    end

    it 'shows the utilization of the real estate' do
      page.should have_content('Miete | Wohnen')
    end

    it 'shows the chapter title' do
      page.should have_content('Objektübersicht')
    end

    it 'shows the property name' do
      page.should have_content('Gartenstadt')
    end

    it 'shows the address' do
      page.should have_content('Musterstrasse 1, 8400 Hausen')
    end

    it 'shows the floor' do
      page.should have_content('Geschoss')
      page.should have_content('3. Obergeschoss')
    end

    it 'shows the number of rooms' do
      page.should have_content('Zimmeranzahl')
      page.should have_content('3.5 Zimmer')
    end

    it 'shows the usable surface' do
      page.should have_content('120 m²')
    end

    it 'shows the helptext for the usable surface' do
      page.should have_content I18n.t('handouts.overview.usable_surface_helptext')
    end

    it 'shows the description' do
      page.should have_content('Lorem Ipsum')
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
      page.should have_css(".floorplan-image img", :count => 1)
    end

    it 'shows the compass direction'
  end

  describe "Chapter Pricing" do

    shared_examples_for "Pricing information shown for all kind of real estates" do
      it "shows the rent price" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('pricings.for_rent_netto')
        page.should have_content "CHF 1'999.00 / Monat"
      end

      it "shows 'without VAT message' if 'opted'" do
        @pricing.update_attribute :opted, true
        visit real_estate_handout_path(@real_estate)
        page.should have_content "Alle Preise ohne Mehrwertsteuer"
      end

      it "shows additional expenses" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('pricings.for_rent_extra')
        page.should have_content "CHF 99.00 / Monat"
      end

      it "shows the price of the inside parking lot if available" do
        visit real_estate_handout_path(@real_estate)
        page.should_not have_content I18n.t('pricings.inside_parking')

        @pricing.update_attribute :inside_parking, 100
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz in Autoeinstellhalle'
        page.should have_content 'CHF 100.00 / Monat'
      end

      it "shows the price of the temporary inside parking lot if available" do
        @pricing.update_attribute :inside_parking_temporary, 50
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz in Autoeinstellhalle temporär'
        page.should have_content 'CHF 50.00 / Monat'
      end

      it "shows the price of the outside parking lot if available" do
        @pricing.update_attribute :outside_parking, 80
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz im Freien'
        page.should have_content 'CHF 80.00 / Monat'
      end

      it "shows the price of the temporary outside parking lot if available" do
        @pricing.update_attribute :outside_parking_temporary, 20
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz im Freien temporär'
        page.should have_content 'CHF 20.00 / Monat'
      end

      it "shows the rent depot price" do
        visit real_estate_handout_path(@real_estate)
        page.should have_content 'Mietzinsdepot'
        page.should have_content 'CHF 4\'000.00'
      end
    end


    context "Real Estate, private, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :for_rent_depot => 4000, :price_unit => 'monthly'
        @real_estate = Fabricate :residential_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

    end


    context "Real Estate, commercial, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :for_rent_depot => 4000, :price_unit => 'monthly', :opted => false
        @real_estate = Fabricate :commercial_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

    end

  end

  describe "Chapter Information" do
    before do
      visit real_estate_handout_path(printable_real_estate)
    end

    it 'shows the chapter title' do
      page.should have_content 'Immobilieninfos'
    end

    it 'shows the availability date' do
      page.should have_content 'Bezug ab'
      page.should have_content 'Mitte Mai'
    end

    it 'shows the characteristics' do
      page.should have_content('Merkmale')
    end

    it 'shows if it is a new building' do
      page.should have_content 'Neubau'
    end

    it 'shows if it is an old building' do
      page.should have_content 'Altbau'
    end

    it 'shows the minergie infos' do
      page.should have_content 'Minergie Bauweise'
      page.should have_content 'Minergie zertifiziert'
    end

    it 'shows if it is under building laws' do
      pending 'figure out what this is supposed to do'
    end

    it 'shows the min rent time' do
      page.should have_content 'Mindestmietdauer'
      page.should have_content '1 Jahr'
    end

    it 'shows the notice dates' do
      page.should have_content 'Kündigungstermine'
      page.should have_content 'September, März'
    end

    it 'shows the notice period' do
      page.should have_content 'Kündigungsfrist'
      page.should have_content '3 Monate'
    end

    context 'real estate for private utilization' do
      it 'has a view' do
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

      it 'has a raised groundfloor' do
        page.should have_content 'Hochparterre'
      end

      it 'has a swimmingpool' do
        page.should have_content 'Schwimmbecken'
      end
    end

    context 'real estate for commercial utilization' do
      before do
        printable_real_estate.update_attribute :utilization, RealEstate::UTILIZATION_COMMERICAL
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
        page.should have_content 'Anfahrtsrampe'
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
    end
  end

  describe "Chapter Descriptions" do
    before do
      visit real_estate_handout_path(printable_real_estate)
    end

    it 'shows the chapter title' do
      page.should have_content 'Beschreibung'
    end

    it 'shows the location description' do
      page.should have_content 'Standort'
      page.should have_content 'Lorem ipsum ... 2. Beschreibung'
    end

    it 'shows the interior description' do
      page.should have_content 'Ausbaustandard'
      page.should have_content 'Lorem ipsum ... 3. Beschreibung'
    end

    it 'shows the offer description' do
      page.should have_content 'Angebot'
      page.should have_content 'Lorem ipsum ... 4. Beschreibung'
    end

    it 'shows the infrastructure description' do
      page.should have_content 'Infrastruktur'
      page.should have_content 'Lorem ipsum ... 5. Beschreibung'
    end

    it 'shows the usage description' do
      page.should have_content 'Nutzung'
      page.should have_content printable_real_estate.utilization_description
    end
  end

  describe "Chapter Contact" do

    before do
      @contact_person = Fabricate :employee
      @real_estate = Fabricate :residential_building, :contact=>@contact_person, :pricing=>Fabricate.build(:pricing_for_rent)
    end

    it "is not available, if contact person is't assigned to real estate" do
      real_estate = Fabricate :residential_building, :pricing=>Fabricate.build(:pricing_for_rent)
      visit real_estate_handout_path(real_estate)

      page.should_not have_css ".chapter.contact"
    end

    it "shows the employees department name" do
      visit real_estate_handout_path(@real_estate)
      within ".chapter.contact" do
        page.should have_content "Vermarktung"
      end
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
  end

  describe "Chapter Pictures" do
    before do
      @primary_image = Fabricate.build :media_asset_image, :is_primary=>true, :title=>"The primary image"
      @ground_plot = Fabricate.build :media_asset_floorplan, :title=>"The beautiful floor plan"
      @kitchen = Fabricate.build(:media_asset_image, :title=>"The kitchen")
      @bathroom = Fabricate.build(:media_asset_image, :title=>"The bathroom")

      @real_estate = Fabricate :residential_building, :contact=>@contact_person, :pricing => Fabricate.build(:pricing_for_rent),
                               :media_assets => [@primary_image, @ground_plot, @kitchen, @bathroom]
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
end
