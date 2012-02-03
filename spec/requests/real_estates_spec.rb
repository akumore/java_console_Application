require "spec_helper"

describe "RealEstates" do

  describe "Visit real estate index path" do
    let :real_estate do
      Fabricate :real_estate,
                :category=>Fabricate(:category, :label=>'Wohnung'),
                :address=>Fabricate.build(:address),
                :figure=>Fabricate.build(:figure, :rooms=>10.5, :floor=>99),
                :pricing=>Fabricate.build(:pricing)
    end

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
        visit real_estates_path
        page.should have_content number_to_currency(real_estate.pricing.for_sale, :locale=>'de-CH')
      end

      it "shows the localized price for rent" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
        visit real_estates_path
        page.should have_content number_to_currency(real_estate.pricing.for_rent_netto, :locale=>'de-CH')
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

end