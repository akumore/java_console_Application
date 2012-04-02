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

  describe 'Vision header' do
    before :each do
      visit root_path
    end

    it 'has a slider' do
      within('.vision-slider') do
        page.should have_css('.flexslider', :count => 1)
      end
    end

    it 'is open by default', :js => true do
      page.should have_css('.vision-slider-open .vision-slider', :count => 1)
    end

    it 'can be toggled', :js => true do
      within('.vision-slider') do
        page.find('.toggle').click
      end
      
      page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

      within('.vision-slider') do
        page.find('.toggle').click
      end

      page.should have_css('.vision-slider-open .vision-slider', :count => 1)
    end

    context 'persisting the toggled state between pages', :js => true do
      it 'is stays closed' do
        # check that it's open by default
        page.should have_css('.vision-slider-open .vision-slider', :count => 1)

        within('.vision-slider') do
          page.find('.toggle').click
        end

        # now it should be closed …
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

        visit root_path

        # … and it should still be after revisiting
        page.should_not have_css('.vision-slider-open .vision-slider', :count => 1)

      end
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
        @real_estate = Fabricate :real_estate,
                                 :title => "Home Sweet Home for rent",
                                 :offer => RealEstate::OFFER_FOR_RENT,
                                 :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL],
                                 :address => Fabricate.build(:address),
                                 :category => Fabricate(:category)
        @image = Fabricate.build :media_asset_image, :is_primary => true
        @real_estate.media_assets << @image
      end

      it "shows the primary image of the appropriate real estate" do
        visit root_path
        within(".rent-slide") do
          page.should have_css("img[src='#{@image.file.url}']")
        end
      end

      it "links to the search" do
        visit root_path
        within(".rent-slide") do
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_rent', :utilization => 'private')}']")
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_rent', :utilization => 'commercial')}']")
        end
      end

      it "shows the title of the real estate" do
        visit root_path
        within(".rent-slide .image-caption-text") do
          page.should have_content @real_estate.title
        end
      end
    end


    describe "The slide for buying real estates" do
      before do
        @real_estate = Fabricate :real_estate,
                                 :title => "Home Sweet Home for sale",
                                 :offer => RealEstate::OFFER_FOR_SALE,
                                 :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL],
                                 :address => Fabricate.build(:address),
                                 :category => Fabricate(:category)
        @image = Fabricate.build :media_asset_image, :is_primary => true
        @real_estate.media_assets << @image
      end

      it "shows the primary image of the appropriate real estate" do
        visit root_path
        within(".sale-slide") do
          page.should have_css("img[src='#{@image.file.url}']")
        end
      end

      it "links to the search" do
        visit root_path
        within(".sale-slide") do
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_sale', :utilization => 'private')}']")
          page.should have_css("a[href='#{real_estates_path(:offer => 'for_sale', :utilization => 'commercial')}']")
        end
      end

      it "shows the title of the real estate" do
        visit root_path
        within(".sale-slide .image-caption-text") do
          page.should have_content @real_estate.title
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
        4.times { Fabricate :news_item }
        visit root_path

        within ".footer-news" do
          page.should have_css("div[id*='footer-news-item-']", :count => 3)
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