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

  describe "Visit real estate index path" do
    before do
      @real_estates = [real_estate, unpublished_real_estate]
    end

    it "shows the number of search result" do
      visit real_estates_path
      page.should have_content "1 Treffer"
    end

    it "renders the search results within a table" do
      visit real_estates_path
      page.should have_selector('table tbody tr', :count => 1)
    end

    it "shows published real estates only" do
      visit real_estates_path
      page.should_not have_css "#real-estate-#{unpublished_real_estate.id}"
      page.should have_css "#real-estate-#{real_estate.id}"
    end


    describe "Shown information about a search results" do
      let :primary_image do
        Fabricate.build(:media_assets_image, :is_primary=>true)
      end

      before { MediaAssetUploader.enable_processing = true }
      after { MediaAssetUploader.enable_processing = false }

      it "shows the lazy loading thumbnail placeholder" do
        real_estate.images << primary_image
        visit real_estates_path
        page.should have_css(%(img[src="/assets/transparent.png"]))
      end

      it "stores the thumbnail of the primary image for the lazy loading" do
        real_estate.images << primary_image
        visit real_estates_path
        page.should have_css(%(img[data-original="#{primary_image.file.thumb.url}"]))
      end

      it "has the json representation for the map coordinates" do
        visit real_estates_path
        page.should have_content(real_estate.to_json(:only => :_id, :methods => :coordinates))
      end

      it "stores the placeholder thumbnail if no primary image is set for the lazy loading" do
        visit real_estates_path
        page.should have_css('img[data-original="/images/fallback/thumb_default.png"]')
      end

      it "shows the title" do
        visit real_estates_path
        page.should have_content real_estate.title
      end

      it "shows the category" do
        visit real_estates_path
        page.should have_content real_estate.category.label
      end

      it "shows the address" do
        visit real_estates_path
        address = real_estate.address
        page.should have_content "#{address.city} #{address.canton.upcase}"
        page.should have_content "#{address.street} #{address.street_number}"
      end

      it "shows the number of rooms" do
        visit real_estates_path
        page.should have_content "#{real_estate.figure.rooms} Zimmer"
      end

      it "shows the floor" do
        visit real_estates_path
        page.should have_content "#{real_estate.figure.floor}. Obergeschoss"
      end

      it "shows the size of the living area" do
        visit real_estates_path
        page.should have_content real_estate.figure.living_surface
      end

      it "shows the availability date" do
        visit real_estates_path
        page.should have_content "Bezug ab sofort"
      end

      it "shows the localized price for sale" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE
        visit real_estates_path(:offer=>RealEstate::OFFER_FOR_SALE)
        page.should have_content number_to_currency(real_estate.pricing.for_sale, :locale=>'de-CH')
      end

      it "shows the localized price for rent" do
        real_estate.update_attribute :offer, RealEstate::OFFER_FOR_RENT
        visit real_estates_path
        page.should have_content number_to_currency(real_estate.pricing.for_rent_brutto, :locale=>'de-CH')
      end
    end

    describe "shows a reference projects slider" do
      context "with projects for rent" do
        before :each do
          3.times do
            Fabricate(:reference_project, :offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE)
          end
          visit real_estates_path(:offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE)
        end

        it "shows the slider container" do
          page.should have_css(".real_estates .flex-container .flexslider")
        end

        it "has 3 slides" do
          page.should have_css(".real_estates ul.slides li", :count => 3)
        end
      end

      context "with projects for sale" do
        before :each do
          2.times do
            Fabricate(:reference_project, :offer => RealEstate::OFFER_FOR_SALE, :utilization => RealEstate::UTILIZATION_PRIVATE)
          end
          visit real_estates_path(:offer => RealEstate::OFFER_FOR_SALE, :utilization => RealEstate::UTILIZATION_PRIVATE)
        end

        it "shows the slider container" do
          page.should have_css(".real_estates .flex-container .flexslider")
        end

        it "has 2 slides" do
          page.should have_css(".real_estates ul.slides li", :count => 2)
        end
      end

      context "with projects for rent and private utilization with active commercial utilization filter" do
        let :real_estate do
          RealEstate.new
        end

        before :each do
          3.times do
            Fabricate(:reference_project, :offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE)
          end
          RealEstate.stub(:working).and_return([real_estate])
          visit real_estates_path(:offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_COMMERICAL)
        end

        it "doesn't show the slider container" do
          page.should_not have_css(".real_estates .flex-container .flexslider")
        end

        it "doesn't have 3 slides" do
          page.should_not have_css(".real_estates ul.slides li", :count => 3)
        end
      end
    end
  end


  describe "Search-Filtering of real estates by offer and utilization" do
    before do
      @non_commercial_for_sale = Fabricate :published_real_estate,
                                           :utilization => RealEstate::UTILIZATION_PRIVATE,
                                           :offer => RealEstate::OFFER_FOR_SALE,
                                           :category => Fabricate(:category),
                                           :address => Fabricate.build(:address),
                                           :figure => Fabricate.build(:figure),
                                           :pricing => Fabricate.build(:pricing_for_sale)

      @commercial_for_sale = Fabricate :published_real_estate,
                                       :utilization => RealEstate::UTILIZATION_COMMERICAL,
                                       :offer => RealEstate::OFFER_FOR_SALE,
                                       :category => Fabricate(:category),
                                       :address => Fabricate.build(:address),
                                       :figure => Fabricate.build(:figure),
                                       :pricing => Fabricate.build(:pricing_for_sale)

      @non_commercial_for_rent = Fabricate :published_real_estate,
                                           :utilization => RealEstate::UTILIZATION_PRIVATE,
                                           :offer => RealEstate::OFFER_FOR_RENT,
                                           :category => Fabricate(:category),
                                           :address => Fabricate.build(:address),
                                           :figure => Fabricate.build(:figure),
                                           :pricing => Fabricate.build(:pricing_for_rent)

      @commercial_for_rent = Fabricate :published_real_estate,
                                       :utilization => RealEstate::UTILIZATION_COMMERICAL,
                                       :offer => RealEstate::OFFER_FOR_RENT,
                                       :category => Fabricate(:category),
                                       :address => Fabricate.build(:address),
                                       :figure => Fabricate.build(:figure),
                                       :pricing => Fabricate.build(:pricing_for_rent)
    end

    it "renders the search filter" do
      visit real_estates_path
      page.should have_css ".search-filter-container"
      within ".search-filter-container" do
        page.should have_css ".offer-tabs"
        page.should have_css ".utilization-tabs"
      end
    end

    it "renders the hooks for the mobile optimized search filter" do
      visit real_estates_path
      within ".search-filter-container" do
        page.should have_css ".js-for_rent"
        page.should have_css ".js-for_sale"
        page.should have_css ".js-living"
        page.should have_css ".js-working"
        page.should have_css ".js-storing"
        page.should have_css ".js-parking"
      end
    end

    it "shows non-commercial offers for sale" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_PRIVATE, :offer=>RealEstate::OFFER_FOR_SALE)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_sale.id}]")
    end

    it "shows non-commercial offers for rent" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_PRIVATE, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_rent.id}]")
    end

    it "shows commercial offers for sale" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_SALE)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_sale.id}]")
    end

    it "shows commercial offers for rent" do
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_rent.id}]")
    end

    it "filters out all real estates because there is no match" do
      @commercial_for_rent.destroy
      visit real_estates_path(:utilization=>RealEstate::UTILIZATION_COMMERICAL, :offer=>RealEstate::OFFER_FOR_RENT)
      page.should_not have_selector('table tbody tr')
    end
  end


  describe 'Search-Filtering of real estates by canton and city' do
    before do
      @arth = Fabricate :published_real_estate,
                        :utilization => RealEstate::UTILIZATION_PRIVATE,
                        :offer => RealEstate::OFFER_FOR_RENT,
                        :category => Fabricate(:category),
                        :address => Fabricate.build(:address, :canton => 'sz', :city => 'Arth'),
                        :figure => Fabricate.build(:figure),
                        :pricing => Fabricate.build(:pricing)

      @goldau = Fabricate :published_real_estate,
                          :utilization => RealEstate::UTILIZATION_PRIVATE,
                          :offer => RealEstate::OFFER_FOR_RENT,
                          :category => Fabricate(:category),
                          :address => Fabricate.build(:address, :canton => 'sz', :city => 'Goldau'),
                          :figure => Fabricate.build(:figure),
                          :pricing => Fabricate.build(:pricing)
      @adliswil = Fabricate :published_real_estate,
                            :utilization => RealEstate::UTILIZATION_PRIVATE,
                            :offer => RealEstate::OFFER_FOR_RENT,
                            :category => Fabricate(:category),
                            :address => Fabricate.build(:address, :canton => 'zh', :city => 'Adliswil'),
                            :figure => Fabricate.build(:figure),
                            :pricing => Fabricate.build(:pricing)

      visit real_estates_path(:utilization => RealEstate::UTILIZATION_PRIVATE, :offer => RealEstate::OFFER_FOR_RENT)

      page.should have_css("tr[id=real-estate-#{@arth.id}]")
      page.should have_css("tr[id=real-estate-#{@goldau.id}]")
      page.should have_css("tr[id=real-estate-#{@adliswil.id}]")
    end

    it "filters by canton" do
      select 'Schwyz'
      click_button 'Suchen'

      page.should have_css("tr[id=real-estate-#{@arth.id}]")
      page.should have_css("tr[id=real-estate-#{@goldau.id}]")
      page.should_not have_css("tr[id=real-estate-#{@adliswil.id}]")
    end

    it 'filters by city' do
      select 'Arth'
      click_button 'Suchen'

      page.should have_css("tr[id=real-estate-#{@arth.id}]")
      page.should_not have_css("tr[id=real-estate-#{@goldau.id}]")
      page.should_not have_css("tr[id=real-estate-#{@adliswil.id}]")
    end

    it 'keeps city field when changing sort order', :js => true do
      select 'Arth'
      click_button 'Suchen'
      select 'Preis'

      page.should have_css("tr[id=real-estate-#{@arth.id}]")
      page.should_not have_css("tr[id=real-estate-#{@goldau.id}]")
    end
  end

end
