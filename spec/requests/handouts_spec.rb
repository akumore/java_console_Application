# encoding: utf-8
require "spec_helper"

describe "Handout aka MiniDoku" do
  monkey_patch_default_url_options

  let :printable_real_estate do
    Fabricate(:residential_building,
        :address => Fabricate.build(:address, :street => 'Musterstrasse', :street_number => '1', :zip => '8400', :city => 'Hausen'),
        :figure => Fabricate.build(:figure, :floor => 3, :rooms => '3.5', :usable_surface => 120),
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :price_unit => 'month'),
        :title => 'Demo Objekt',
        :description => 'Lorem Ipsum',
        :property_name => 'Gartenstadt',
        :media_assets => [
          Fabricate.build(:media_asset_floorplan)
        ]
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
      page.should have_content('Miete Privat')
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
      page.should have_content('3. Obergeschoss')
    end

    it 'shows the number of rooms' do
      page.should have_content('3.5')
    end

    it 'shows the usable surface' do
      page.should have_content('120m2')
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

        page.should have_content I18n.t('handouts.pricing.for_rent_netto')
        page.should have_content "CHF 1'999.00 monatlich"
      end

      it "shows 'without VAT message' if 'opted'" do
        @pricing.update_attribute :opted, true
        visit real_estate_handout_path(@real_estate)
        page.should have_content "Alle Preise ohne Mehrwertsteuer"
      end

      it "shows additional expenses" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('handouts.pricing.for_rent_extra')
        page.should have_content "CHF 99.00 monatlich"
      end

      it "shows the price of the inside parking lot if available" do
        visit real_estate_handout_path(@real_estate)
        page.should_not have_content I18n.t('handouts.pricing.inside_parking')

        @pricing.update_attribute :inside_parking, 100
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz in Autoeinstellhalle'
        page.should have_content 'CHF 100.00 monatlich'
      end

      it "shows the price of the temporary inside parking lot if available" do
        @pricing.update_attribute :inside_parking_temporary, 50
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz in Autoeinstellhalle temporär'
        page.should have_content 'CHF 50.00 monatlich'
      end

      it "shows the price of the outside parking lot if available" do
        @pricing.update_attribute :outside_parking, 80
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz nicht überdacht'
        page.should have_content 'CHF 80.00 monatlich'
      end

      it "shows the price of the temporary outside parking lot if available" do
        @pricing.update_attribute :outside_parking_temporary, 20
        visit real_estate_handout_path(@real_estate)

        page.should have_content 'Parkplatz nicht überdacht temporär'
        page.should have_content 'CHF 20.00 monatlich'
      end

      it "shows the rent depot price"
    end


    context "Real Estate, private, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :price_unit => 'month'
        @real_estate = Fabricate :residential_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

    end


    context "Real Estate, commercial, for rent" do
      before do
        @pricing = Fabricate.build :pricing_for_rent, :for_rent_netto => 1999, :for_rent_extra => 99, :price_unit => 'month', :opted => false
        @real_estate = Fabricate :commercial_building, :pricing => @pricing
      end

      it_should_behave_like "Pricing information shown for all kind of real estates"

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

end
