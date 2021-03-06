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
              :contact => Fabricate(:employee)
  end

  let :unpublished_real_estate do
    Fabricate :real_estate,
              :category => category,
              :address => Fabricate.build(:address),
              :figure => Fabricate.build(:figure, :rooms => 20, :floor => 1),
              :pricing => Fabricate.build(:pricing),
              :contact => Fabricate(:employee)
  end

  let :parking_category do
    Fabricate(:parking_category)
  end

  before do
    Fabricate(:page, title: 'Angebot', name: 'real_estates')
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

    context 'for rent and living real estates overview' do
      it 'does render the adwebster retargeting pixels' do
        Rails.stub_chain(:env, :production?).and_return(true)
        visit real_estates_path(offer: Offer::RENT, utilization: Utilization::LIVING)
        expect(page.html).to match('<!-- Begin ADWEBSTER.COM -->')
      end
    end

    context 'for rent and working real estates overview' do
      it 'renders the adwebster retargeting pixels' do
        Rails.stub_chain(:env, :production?).and_return(true)
        visit real_estates_path(offer: Offer::RENT, utilization: Utilization::WORKING)
        expect(page.html).to match('<!-- Begin ADWEBSTER.COM -->')
      end
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
        page.html.should have_content(real_estate.to_json(:only => :_id, :methods => :coordinates))
      end

      it "stores the placeholder thumbnail if no primary image is set for the lazy loading" do
        visit real_estates_path
        page.should have_css('img[data-original="/images/fallback/thumb_default.png"]')
      end

      it "shows the title" do
        visit real_estates_path
        page.should have_content real_estate.title
      end

      it "does not show the category" do
        visit real_estates_path
        page.should_not have_content real_estate.category.label
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

      it "does not show the size of the living area" do
        visit real_estates_path
        page.should_not have_content real_estate.figure.living_surface
      end

      it "shows the availability date" do
        visit real_estates_path
        page.should have_content "ab sofort"
      end

      it "shows the localized price for sale" do
        real_estate.update_attribute :offer, Offer::SALE
        visit real_estates_path(:offer => Offer::SALE)
        page.should have_content '1.3 Mio. CHF'
      end

      it "shows the localized price for rent" do
        real_estate.update_attribute :offer, Offer::RENT
        visit real_estates_path
        page.should have_content '1 620.00 CHF'
      end
    end

    describe "shows a reference projects slider" do
      context "with projects for rent" do
        before :each do
          3.times do
            Fabricate(:reference_project, :offer => Offer::RENT, :utilization => Utilization::LIVING)
          end
          visit real_estates_path(:offer => Offer::RENT, :utilization => Utilization::LIVING)
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
            Fabricate(:reference_project, :offer => Offer::SALE, :utilization => Utilization::LIVING)
          end
          visit real_estates_path(:offer => Offer::SALE, :utilization => Utilization::LIVING)
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
            Fabricate(:reference_project, :offer => Offer::RENT, :utilization => Utilization::LIVING)
          end
          RealEstate.stub_chain(:for_rent, :working).and_return([real_estate])
          visit real_estates_path(:offer => Offer::RENT, :utilization => Utilization::WORKING)
        end

        it "doesn't show the slider container" do
          page.should_not have_css(".real_estates .flex-container .flexslider")
        end

        it "doesn't have 3 slides" do
          page.should_not have_css(".real_estates ul.slides li", :count => 3)
        end
      end
    end

    context 'in the parking category' do
      before do
        real_estate.update_attributes(:category => parking_category,
                                      :utilization => Utilization::PARKING)
        visit real_estates_path
        click_on 'Parkieren'
      end

      it 'shows the parking thumbnail' do
        page.should have_css(%(img[data-original="#{RealEstateDecorator.decorate(real_estate).thumbnail}"]))
      end
    end
  end


  describe "Search-Filtering of real estates by offer and utilization" do
    before do
      @non_commercial_for_sale = Fabricate :published_real_estate,
                                           :utilization => Utilization::LIVING,
                                           :offer => Offer::SALE,
                                           :category => Fabricate(:category),
                                           :address => Fabricate.build(:address),
                                           :figure => Fabricate.build(:figure),
                                           :pricing => Fabricate.build(:pricing_for_sale)

      @commercial_for_sale = Fabricate :published_real_estate,
                                       :utilization => Utilization::WORKING,
                                       :offer => Offer::SALE,
                                       :category => Fabricate(:category),
                                       :address => Fabricate.build(:address),
                                       :figure => Fabricate.build(:figure),
                                       :pricing => Fabricate.build(:pricing_for_sale)

      @non_commercial_for_rent = Fabricate :published_real_estate,
                                           :utilization => Utilization::LIVING,
                                           :offer => Offer::RENT,
                                           :category => Fabricate(:category),
                                           :address => Fabricate.build(:address),
                                           :figure => Fabricate.build(:figure),
                                           :pricing => Fabricate.build(:pricing_for_rent)

      @commercial_for_rent = Fabricate :published_real_estate,
                                       :utilization => Utilization::WORKING,
                                       :offer => Offer::RENT,
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
      end
    end

    it "shows non-commercial offers for sale" do
      visit real_estates_path(:utilization => Utilization::LIVING, :offer => Offer::SALE)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_sale.id}]")
    end

    it "shows non-commercial offers for rent" do
      visit real_estates_path(:utilization => Utilization::LIVING, :offer => Offer::RENT)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@non_commercial_for_rent.id}]")
    end

    it "shows commercial offers for sale" do
      visit real_estates_path(:utilization => Utilization::WORKING, :offer => Offer::SALE)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_sale.id}]")
    end

    it "shows commercial offers for rent" do
      visit real_estates_path(:utilization => Utilization::WORKING, :offer => Offer::RENT)
      page.should have_selector('table tbody tr', :count => 1)
      page.should have_css("tr[id=real-estate-#{@commercial_for_rent.id}]")
    end

    describe 'default utilization behaviour' do
      context "if real estates don't exists for this offer and utilization combination" do
        before do
          @commercial_for_rent.destroy
        end

        it "filters out all real estates because there is no match" do
          visit real_estates_path(:utilization => Utilization::WORKING, :offer => Offer::RENT)
          page.should have_css("tr[id=real-estate-#{@non_commercial_for_rent.id}]")
        end
      end
    end
  end

  describe 'Search-Filtering of real estates by canton and city' do
    before do
      @arth = Fabricate :published_real_estate,
                        :utilization => Utilization::LIVING,
                        :offer => Offer::RENT,
                        :category => Fabricate(:category),
                        :address => Fabricate.build(:address, :canton => 'sz', :city => 'Arth'),
                        :figure => Fabricate.build(:figure),
                        :pricing => Fabricate.build(:pricing)

      @goldau = Fabricate :published_real_estate,
                          :utilization => Utilization::LIVING,
                          :offer => Offer::RENT,
                          :category => Fabricate(:category),
                          :address => Fabricate.build(:address, :canton => 'sz', :city => 'Goldau'),
                          :figure => Fabricate.build(:figure),
                          :pricing => Fabricate.build(:pricing)
      @adliswil = Fabricate :published_real_estate,
                            :utilization => Utilization::LIVING,
                            :offer => Offer::RENT,
                            :category => Fabricate(:category),
                            :address => Fabricate.build(:address, :canton => 'zh', :city => 'Adliswil'),
                            :figure => Fabricate.build(:figure),
                            :pricing => Fabricate.build(:pricing)

      visit real_estates_path(:utilization => Utilization::LIVING, :offer => Offer::RENT)

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
