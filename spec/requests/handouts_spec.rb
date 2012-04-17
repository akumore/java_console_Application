# encoding: utf-8
require "spec_helper"

describe "Handout aka MiniDoku" do
  monkey_patch_default_url_options

  describe "Chapter Pricing" do

    shared_examples_for "Pricing information shown for all kind of real estates" do
      it "shows the rent price" do
        visit real_estate_handout_path(@real_estate)

        page.should have_content I18n.t('handouts.pricing.for_rent_netto')
        page.should have_content "CHF 1'999.00 monatlich"
      end

      it "marks the rent price opted if 'opted'" do
        @pricing.update_attribute :opted, true
        visit real_estate_handout_path(@real_estate)
        page.should have_content "CHF 1'999.00 monatlich (ohne Mehrwertsteuer)"
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
end