# encoding: utf-8
require "spec_helper"

describe "Homepage" do
  monkey_patch_default_url_options

  context "Visiting the home page" do
    it 'shows the logo of Alfred Mueller' do
      visit root_path
      page.should have_css ".main-logo"
    end

    it 'shows the services slider app containing reference project carousels' do
      visit root_path
      page.should have_css ".services-slides-container"
    end
  end

  describe "Services Slider App" do
    it "contains a slide for renting real estates" do
      visit root_path
      page.should have_css ".rent-slide"
    end

    it "contains a slide for selling real estates" do
      visit root_path
      page.should have_css ".sale-slide"
    end

    it "contains a slide for advertisement about build abilities" do
      visit root_path
      page.should have_css ".build-slide"
    end


    describe "The slide for renting real estates" do
      before do
        MediaAssetUploader.enable_processing = true
        @reference_project_for_rent = Fabricate :reference_project_for_rent
      end

      let :real_estate do
        RealEstate.new
      end

      after do
        MediaAssetUploader.enable_processing = false
      end

      it "shows the primary image of the appropriate real estate" do
        visit root_path
        within(".rent-slide") do
          page.should have_css("img[src='#{@reference_project_for_rent.image.gallery.url}']")
        end
      end

      it "links to the search" do
        RealEstate.stub_chain(:for_rent, :working).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :living).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :storing).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :parking).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :working).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :living).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :storing).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :parking).and_return([real_estate])

        visit root_path

        within(".rent-slide") do
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_rent', :utilization => 'private')}']")
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_rent', :utilization => 'commercial')}']")
        end
      end

      it "shows the title of the reference project" do
        visit root_path
        within(".rent-slide .image-caption-text") do
          page.should have_content @reference_project_for_rent.title
        end
      end

      describe "with real estate reference" do

        describe "with real estate published" do
          it "shows the link of the reference project" do
            real_estate = Fabricate :residential_building, :state => RealEstate::STATE_PUBLISHED
            puts real_estate.published?
            ref = Fabricate :reference_project_for_rent, :real_estate => real_estate
            visit root_path
            page.should have_link("Zum Projekt"), :href => real_estate_path(real_estate)
          end
        end

        describe "without real estate published" do
          it "shows the link of the reference project" do
            real_estate = Fabricate :residential_building, :state => RealEstate::STATE_EDITING
            ref = Fabricate :reference_project_for_rent, :real_estate => real_estate
            visit root_path
            page.should_not have_link("Zum Projekt", :href => real_estate_path(real_estate))
          end
        end
      end

      describe "with url" do
        before do
          @reference_project_with_url = Fabricate :reference_project_for_rent, :url => 'link_to_project_website'
        end

        it "shows the link to the project page in the slider" do
          visit root_path
          page.should have_css("a[href='link_to_project_website']")
        end
      end

      describe "with referenced real estate" do
        let :real_estate do
          Fabricate(:residential_building)
        end

        before do
          @reference_project_with_url = Fabricate :reference_project_for_rent, :real_estate => real_estate
        end

        it "shows the link to the real estate in the slider" do
          visit root_path
          page.should have_css("a[href='#{real_estate_path real_estate, :offer => 'for_rent', :utilization => 'private'}']")
        end
      end

    end


    describe "The slide for buying real estates" do
      before do
        MediaAssetUploader.enable_processing = true
        @reference_project_for_sale = Fabricate :reference_project_for_sale
      end

      let :real_estate do
        RealEstate.new
      end

      after do
        MediaAssetUploader.enable_processing = false
      end

      it "shows the primary image of the appropriate real estate" do
        visit root_path
        within(".sale-slide") do
          page.should have_css("img[src='#{@reference_project_for_sale.image.gallery.url}']")
        end
      end

      it "links to the search" do
        RealEstate.stub_chain(:for_rent, :working).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :living).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :storing).and_return([real_estate])
        RealEstate.stub_chain(:for_rent, :parking).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :working).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :living).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :storing).and_return([real_estate])
        RealEstate.stub_chain(:for_sale, :parking).and_return([real_estate])

        visit root_path

        within(".sale-slide") do
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_sale', :utilization => 'private')}']")
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_sale', :utilization => 'commercial')}']")
        end
      end

      it "shows the title of the real estate" do
        visit root_path
        within(".sale-slide .image-caption-text") do
          page.should have_content @reference_project_for_sale.title
        end
      end
    end
  end


  describe "Footer" do
    describe "News Items" do
      before do
        @news_item = Fabricate :news_item
      end

      it "shows not more than three items" do
        5.times { Fabricate :news_item }
        visit root_path

        within ".footer-news" do
          page.should have_css("div[id*='footer-news-item-']", :count => 4)
        end
      end

      it "shows the date" do
        visit root_path

        within "#footer-news-item-#{@news_item.id}" do
          page.should have_content I18n.l(@news_item.date)
        end
      end

      it "shows the title" do
        visit root_path

        within "#footer-news-item-#{@news_item.id}" do
          page.should have_content @news_item.title
        end
      end

      it "links to a particular item using anchor" do
        visit root_path

        within "#footer-news-item-#{@news_item.id}" do
          page.should have_link("Mehr erfahren", :href => "#{news_items_path}#news_item_#{@news_item.id}")
        end
      end
    end
  end

end
