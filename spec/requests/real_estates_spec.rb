# encoding: utf-8

require "spec_helper"

describe "RealEstates" do
  let :real_estate do
    Fabricate :real_estate,
              :category=>Fabricate(:category, :label=>'Wohnung'),
              :address=>Fabricate.build(:address),
              :figure=>Fabricate.build(:figure, :rooms=>10.5, :floor=>99),
              :pricing=>Fabricate.build(:pricing),
              :infrastructure => Fabricate.build(:infrastructure)
  end

  describe "Visit real estate index path" do
    before do
      @real_estates = [real_estate]
    end

    it "shows the number of search result" do
      visit real_estates_path
      page.should have_content "#{@real_estates.size} Treffer"
    end

    it "renders the search results within a table" do
      visit real_estates_path
      page.should have_selector('table tr', :count => @real_estates.size)
    end

    describe "Shown information about a search results" do
      let :primary_image do
        Fabricate.build(:media_asset_image, :is_primary=>true)
      end

      it "shows the thumbnail of the primary image" do
        real_estate.media_assets << primary_image
        visit real_estates_path
        page.should have_css(%(img[src="#{primary_image.file.thumb.url}"]))
      end

      it "shows the placeholder thumbnail if no primary image is set" do
        visit real_estates_path
        page.should have_css('img[src="/images/fallback/thumb_default.png"]')
      end

      it "shows the address" do
        visit real_estates_path
        address = real_estate.address
        page.should have_content real_estate.category.label
        page.should have_content "#{address.city} #{address.canton.upcase}"
        page.should have_content "#{address.street} #{address.street_number}"
      end

      it "shows the number of rooms" do
        visit real_estates_path
        page.should have_content "#{real_estate.figure.rooms} Zimmer"
      end

      it "shows the floor" do
        visit real_estates_path
        page.should have_content "#{real_estate.figure.floor}. Stockwerk"
      end

      it "shows the size of the living area" do
        visit real_estates_path
        page.should have_content real_estate.figure.living_surface
      end

      it "shows the localized price for sale" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE
        visit real_estates_path(:offer=>RealEstate::OFFER_FOR_SALE)
        page.should have_content number_to_currency(real_estate.pricing.for_sale, :locale=>'de-CH')
      end

      it "shows the localized price for rent" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
        visit real_estates_path
        page.should have_content number_to_currency(real_estate.pricing.for_rent_netto, :locale=>'de-CH')
      end
    end

    describe "shows a reference projects slider" do
      context "with projects for rent" do
        before :each do
          3.times do
            Fabricate(:real_estate,
              :offer => RealEstate::OFFER_FOR_RENT,
              :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL],
              :category => Fabricate(:category),
              :address => Fabricate.build(:address),
              :media_assets => [Fabricate.build(:media_asset_image, :is_primary => :true)]
            )
          end
          visit real_estates_path(:offer => RealEstate::OFFER_FOR_RENT)
        end

        it "shows the slider container" do
          page.should have_css(".reference-projects-slider")
        end

        it "has 3 slides" do
          page.should have_css("ul.slides li", :count => 3)
        end
      end

      context "with projects for sale" do
        before :each do
          2.times do
            Fabricate(:real_estate,
              :offer => RealEstate::OFFER_FOR_SALE,
              :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL],
              :category => Fabricate(:category),
              :address => Fabricate.build(:address),
              :media_assets => [Fabricate.build(:media_asset_image, :is_primary => :true)]
            )
          end
          visit real_estates_path(:offer => RealEstate::OFFER_FOR_SALE)
        end

        it "shows the slider container" do
          page.should have_css(".reference-projects-slider")
        end

        it "has 2 slides" do
          page.should have_css("ul.slides li", :count => 2)
        end
      end
    end
  end

  describe "Search-Filtering of real estates" do
    before do
      @non_commercial_for_sale = Fabricate :real_estate,
                                           :utilization=>RealEstate::UTILIZATION_PRIVATE,
                                           :offer=>RealEstate::OFFER_FOR_SALE,
                                           :category=>Fabricate(:category),
                                           :address=>Fabricate.build(:address),
                                           :figure=>Fabricate.build(:figure),
                                           :pricing=>Fabricate.build(:pricing)
      @commercial_for_sale = Fabricate :real_estate,
                                       :utilization=>RealEstate::UTILIZATION_COMMERICAL,
                                       :offer=>RealEstate::OFFER_FOR_SALE,
                                       :category=>Fabricate(:category),
                                       :address=>Fabricate.build(:address),
                                       :figure=>Fabricate.build(:figure),
                                       :pricing=>Fabricate.build(:pricing)
      @non_commercial_for_rent = Fabricate :real_estate,
                                           :utilization=>RealEstate::UTILIZATION_PRIVATE,
                                           :offer=>RealEstate::OFFER_FOR_RENT,
                                           :category=>Fabricate(:category),
                                           :address=>Fabricate.build(:address),
                                           :figure=>Fabricate.build(:figure),
                                           :pricing=>Fabricate.build(:pricing)
      @commercial_for_rent = Fabricate :real_estate,
                                       :utilization=>RealEstate::UTILIZATION_COMMERICAL,
                                       :offer=>RealEstate::OFFER_FOR_RENT,
                                       :category=>Fabricate(:category),
                                       :address=>Fabricate.build(:address),
                                       :figure=>Fabricate.build(:figure),
                                       :pricing=>Fabricate.build(:pricing)
    end

    it "renders the search filter" do
      visit real_estates_path
      page.should have_css ".search-filter-container"
      within ".search-filter-container" do
        page.should have_css ".offer-tabs"
        page.should have_css ".utilization-tabs"
      end
    end

    it "shows non-commercial offers for sale" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_PRIVATE, :offer=>RealEstate::OFFER_FOR_SALE)
      page.should have_selector('table tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_sale.id}]")
    end

    it "shows non-commercial offers for rent" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_PRIVATE, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should have_selector('table tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_rent.id}]")
    end

    it "shows commercial offers for sale" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_SALE)
      page.should have_selector('table tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_sale.id}]")
    end

    it "shows commercial offers for rent" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should have_selector('table tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_rent.id}]")
    end

    it "filters out all real estates because there is no match" do
      @commercial_for_rent.destroy
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should_not have_selector('table tr')
    end
  end

  describe 'Visit real estate show path' do
    before :each do
      visit real_estate_path(real_estate)
    end

    it 'shows the title' do
      page.should have_content(real_estate.title)
    end

    it 'shows the description' do
      page.should have_content(real_estate.description)
    end

    it 'has keywords for the search engine' do
      page.should have_css("meta[content='#{real_estate.keywords}']")
    end

    it 'has a description for the search engine' do
      page.should have_css("meta[content='#{real_estate.short_description}']")
    end

    it 'has a link to the search results' do
      page.should have_link('Übersicht')
    end

    it "shows the address" do
      address = real_estate.address
      page.should have_content real_estate.category.label
      page.should have_content "#{address.city} #{address.canton.upcase}"
      page.should have_content "#{address.street} #{address.street_number}"
    end

    it "shows the number of rooms" do
      page.should have_content "#{real_estate.figure.rooms} Zimmer"
    end

    it "shows the floor" do
      page.should have_content "#{real_estate.figure.floor}. Stockwerk"
    end

    it "shows the size of the living area" do
      page.should have_content real_estate.figure.living_surface
    end

    context 'when the real estate is for rent' do
      it "shows the localized price for rent" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
        visit real_estate_path(real_estate)
        page.should have_content number_to_currency(real_estate.pricing.for_rent_netto, :locale=>'de-CH')
      end
    end

    context 'when the real estate is for sale' do
      it "shows the localized price for sale" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE
        visit real_estate_path(real_estate)
        page.should have_content number_to_currency(real_estate.pricing.for_sale, :locale=>'de-CH')
      end
    end

    it 'has a link to the next search result' do
      page.should have_link('Nächstes Projekt')
    end

    it 'has a link to the mini doku' do
      page.should have_link('Objektbeschrieb')
    end

    it 'has a link to the floorplan' do
      page.should have_link('Grundriss anzeigen')
    end

    context 'clicking the floorplan link' do
      it 'opens the floorplan in an overlay' do
        pending 'tbd'
      end
    end
  end
end