# encoding: utf-8

require "spec_helper"

describe "RealEstates" do
  monkey_patch_default_url_options

  let :category do
    Fabricate(:category, :label => 'Wohnung')
  end

  let :real_estate do
    Fabricate :published_real_estate,
              :category => category,
              :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
              :address => Fabricate.build(:address),
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :infrastructure => Fabricate.build(:infrastructure),
              :additional_description => Fabricate.build(:additional_description),
              :contact => Fabricate(:employee)
  end

  let :unpublished_real_estate do
    Fabricate :real_estate,
              :category => category,
              :address => Fabricate.build(:address),
              :figure => Fabricate.build(:figure, :rooms => 20, :floor => 1),
              :pricing => Fabricate.build(:pricing),
              :infrastructure => Fabricate.build(:infrastructure),
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
    before :each do
      visit real_estate_path(real_estate)
    end

    it 'has a description for the search engine' do
      page.should have_css("meta[content='#{RealEstateDecorator.new(real_estate).seo_description}']")
    end

    describe 'header area' do
      it 'shows the title' do
        page.should have_content(real_estate.title)
      end

      it 'shows the property name' do
        page.should have_content(real_estate.property_name)
      end

      describe 'short infos' do
        it "shows the address" do
          page.within('.short-info') do
            address = real_estate.address
            page.should have_content "#{address.city} #{address.canton.upcase}"
            page.should have_content "#{address.street} #{address.street_number}"
          end
        end

        it 'shows the utilization description' do
          page.within('.short-info') do
            page.should have_content(RealEstateDecorator.new(real_estate).utilization_description)
          end
        end

        it 'shows the price' do
          page.within('.short-info') do
          end
        end

        it "shows the number of rooms" do
          page.within('.short-info') do
            page.should have_content "#{real_estate.figure.rooms} Zimmer"
          end
        end

        it "shows the floor" do
          page.within('.short-info') do
            page.should have_content "#{real_estate.figure.floor}. Obergeschoss"
          end
        end

        it 'shows the surface size' do
          page.within('.short-info') do
            page.should have_content real_estate.figure.living_surface
          end
        end

        it 'shows the availability date' do
          page.within('.short-info') do
          end
        end
      end
    end

    describe 'accordion' do
      describe 'descriptions' do
        it 'shows the description' do
          page.should have_content(real_estate.description)
        end

        it 'shows the location description' do
          page.should have_css('h3:contains(Standort)')
          page.should have_content real_estate.additional_description.location
        end

        it 'shows the interior description' do
          page.should have_css('h3:contains(Ausbaustandard)')
          page.should have_content real_estate.additional_description.interior
        end

        it 'shows the offer description' do
          page.should have_css('h3:contains(Angebot)')
          page.should have_content real_estate.additional_description.offer
        end

        it 'shows the infrastructure description' do
          page.should have_css('h3:contains(Infrastruktur)')
          page.should have_content real_estate.additional_description.infrastructure
        end
      end

      describe 'information' do

        context 'when the real estate is for rent' do
          before :each do
            real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
            visit real_estate_path(real_estate)
          end

          it 'shows the min rent time' do
            page.should have_content 'Mindestmietdauer'
            page.should have_content '1 Jahr'
          end

          it 'shows the notice dates' do
            page.should have_content 'Kündigungstermine'
            page.should have_content 'September, Oktober'
          end

          it 'shows the notice period' do
            page.should have_content 'Kündigungsfrist'
            page.should have_content '3 Monate'
          end
        end
      end

      describe 'prices' do
        context 'when the real estate is for rent' do
          before :each do
            real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
            real_estate.update_attribute :channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
            visit real_estate_path(real_estate)
          end

          it "shows the localized price for rent" do
            page.should have_content number_to_currency(real_estate.pricing.for_rent_netto, :locale=>'de-CH')
          end
        end

        context 'when the real estate is for sale' do
          before :each do
            real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE
            visit real_estate_path(real_estate)
          end

          it "shows the localized price for sale" do
            page.should have_content number_to_currency(real_estate.pricing.for_sale, :locale=>'de-CH')
          end
        end
      end

      describe 'contact' do
        it 'displays the full name of the responsible person' do
          page.should have_content(real_estate.contact.fullname)
          page.should have_content(real_estate.contact.phone)
          page.should have_content(real_estate.contact.fax)
          page.should have_content(real_estate.contact.mobile)
          page.should have_link('E-Mail')
        end
      end
    end

    describe 'sidebar' do
      it 'shows the project website link' do
        page.within('.sidebar') do
          page.should have_link 'Zur Projektwebseite', :href => real_estate.address.link_url
        end
      end

      context 'when the real estate is for rent' do
        it 'has a link to the mini doku' do
          real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
          real_estate.update_attribute :channels, [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
          visit real_estate_path(real_estate)
          page.within('.sidebar') do
            page.should have_link('Objektdokumentation')
          end
        end
      end

      context 'when the real estate is for sale' do
        it 'has no link to the mini doku' do
          real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE
          visit real_estate_path(real_estate)
          page.within('.sidebar') do
            page.should_not have_link('Objektbeschrieb')
          end
        end
      end
    end

    it 'has a link to the next search result' do
      page.should have_link('Nächstes Projekt')
    end

    it "has a map of the real estate location" do
      page.should have_css(".map", :count => 1)
    end

    it "has the json representation of the location" do
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

      it 'shows the floorplan slide with a zoom button' do
        page.should have_css('.flexslider .slides li .zoom-floorplan')
      end

      it 'zooms the floorplan in an overlay', :js => true do
        find('.flexslider .slides li .zoom-floorplan').click
        page.should have_css(".fancybox-opened img[src='#{@real_estate_with_floorplan.floor_plans.first.file.url}']")
      end
    end

    context 'not having a floorplan', :fp => true do
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

      it "sends an appointment mail upon submitting the form" do
        visit real_estate_path(real_estate)
        within(".appointment") do
          fill_in 'appointment_firstname', :with => 'Hans'
          fill_in 'appointment_lastname', :with => 'Muster'
          fill_in 'appointment_email', :with => 'hans.muster@test.ch'
          fill_in 'appointment_phone', :with => '123 456 66 44'
        end

        lambda {
          click_on 'Kontaktieren Sie mich'
        }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end

  end
end
