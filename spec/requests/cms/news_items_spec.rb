# encoding: utf-8
require 'spec_helper'

describe "Cms News Items Administration" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:news_item) }
      3.times { Fabricate(:news_item, :locale => :fr) }
      @news_item = NewsItem.first
      visit cms_news_items_path
    end

    describe 'language tabs' do
      it 'shows a tab for every content language' do
        I18n.available_locales.each do |locale|
          page.should have_link(I18n.t("languages.#{locale}"))
        end
      end

      it 'has the DE tab activated by default' do
        page.should have_css('li.active:contains(DE)')
      end

      it 'selects the tab according to the content langauge' do
        visit cms_news_items_path(:content_language => :fr)
        page.should have_css('li.active:contains(FR)')
      end
    end

    it "shows the list of news items for the current content locale" do
      page.should have_selector('table tr', :count => NewsItem.where(:locale => :de).count + 1)
    end

    it "takes me to the edit page of a news_item" do
      within("#news_item_#{@news_item.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_news_item_path(@news_item)
    end

    it "takes me to the page for creating a new news item" do
      page.click_link 'Neue News erstellen'
      current_path.should == new_cms_news_item_path
    end
  end

  describe "#new" do
    it "creates a news item" do
      visit new_cms_news_item_path

      fill_in 'news_item_title', :with => 'Invasion vom Mars'
      fill_in 'news_item_teaser', :with => 'Visit me at the page footer'
      fill_in 'news_item_content', :with => 'Das ist ja kaum zu glauben!'

      expect { click_button 'News erstellen' }.should change(NewsItem, :count).by(1)
      page.should have_content I18n.t("cms.news_items.create.success")
    end

    it "doesn't create because of validation errors" do
      visit new_cms_news_item_path

      expect { click_button 'News erstellen' }.should_not change(NewsItem, :count)
      page.current_path.should == '/cms/news_items' #actual this is the create path
    end

    it "shows validation errors" do
      visit new_cms_news_item_path
      click_button 'News erstellen'

      within ".alert" do
        page.should have_content 'Titel muss ausgefüllt werden'
        page.should have_content 'Inhalt für Footer muss ausgefüllt werden'
        page.should have_content 'Inhalt muss ausgefüllt werden'
      end
    end

    it "creates news item within the chosen language" do
      visit new_cms_news_item_path :content_locale => 'it'

      fill_in 'news_item_title', :with => 'it: Invasion vom Mars'
      fill_in 'news_item_teaser', :with => 'it: Visit me at the page footer'
      fill_in 'news_item_content', :with => 'it: Das ist ja kaum zu glauben!'

      expect { click_button 'News erstellen' }.should change(NewsItem, :count).by(1)
      NewsItem.where(:title => 'it: Invasion vom Mars').first.locale.should == 'it'
    end

    it 'adds images to the news item' do
      visit new_cms_news_item_path

      fill_in 'news_item_title', :with => 'Hello'
      fill_in 'news_item_teaser', :with => 'Visit me at the page footer'
      fill_in 'news_item_content', :with => 'Hello World'
      attach_file 'news_item_images_attributes_0_file', "#{Rails.root}/spec/support/test_files/image.jpg"

      click_button 'News erstellen'
      NewsItem.where(:title => 'Hello').first.images.count.should == 1
    end

    it 'adds documents to the news item' do
      visit new_cms_news_item_path

      fill_in 'news_item_title', :with => 'Hello'
      fill_in 'news_item_teaser', :with => 'Visit me at the page footer'
      fill_in 'news_item_content', :with => 'Hello World'
      attach_file 'news_item_documents_attributes_0_file', "#{Rails.root}/spec/support/test_files/document.pdf"

      click_button 'News erstellen'
      NewsItem.where(:title => 'Hello').first.documents.count.should == 1
    end
  end

  describe "#edit" do
    before do
      @news_item = Fabricate :news_item
      @content_for_update = Fabricate.attributes_for :news_item
    end

    [:title, :teaser, :content].each do |attr|
      it "updates the news item #{attr}" do
        visit edit_cms_news_item_path(@news_item)
        fill_in "news_item_#{attr}", :with => @content_for_update[attr]

        click_button 'News speichern'
        NewsItem.find(@news_item.id).send(attr).should == @content_for_update[attr]
        page.should have_content I18n.t("cms.news_items.update.success")
      end

      it "doesn't update because of validation error caused by #{attr}" do
        visit edit_cms_news_item_path(@news_item)
        fill_in "news_item_#{attr}", :with => ""

        click_button 'News speichern'
        page.should have_content "#{NewsItem.human_attribute_name(attr)} muss ausgefüllt werden"
      end
    end

    it "redirects if requested news item can't be found" do
      visit edit_cms_news_item_path Fabricate.build(:news_item).id
      current_path.should == cms_news_items_path
    end

    it 'adds images to the news item' do
      visit edit_cms_news_item_path(@news_item)
      within ".images-table" do
        attach_file 'news_item_images_attributes_0_file', "#{Rails.root}/spec/support/test_files/image.jpg"
      end
      click_button 'News speichern'

      visit edit_cms_news_item_path(@news_item)
      page.should have_css "#image-#{@news_item.reload.images.first.id}"
    end

    it 'removes images from the news item' do
      image = Fabricate.build(:news_item_image)
      @news_item.images << image
      visit edit_cms_news_item_path(@news_item)

      page.should have_css "#image-#{image.id}"

      check "news_item_images_attributes_0__destroy"
      click_button 'News speichern'

      page.should_not have_css "#image-#{image.id}"
    end

    it 'adds documents to the news item' do
      visit edit_cms_news_item_path(@news_item)
      within ".documents-table" do
        attach_file 'news_item_documents_attributes_0_file', "#{Rails.root}/spec/support/test_files/document.pdf"
      end
      click_button 'News speichern'

      visit edit_cms_news_item_path(@news_item)
      page.should have_css "#document-#{@news_item.reload.documents.first.id}"
    end

    it 'removes documents from the news item' do
      doc = Fabricate.build(:news_item_document)
      @news_item.documents << doc
      visit edit_cms_news_item_path(@news_item)

      page.should have_css "#document-#{doc.id}"

      check "news_item_documents_attributes_0__destroy"
      click_button 'News speichern'

      page.should_not have_css "#document-#{doc.id}"
    end
  end


  it 'destroys a certain news item' do
    news_item = Fabricate :news_item
    visit cms_news_items_path
    within "#news_item_#{news_item.id}" do
      expect { click_link "Löschen" }.should change(NewsItem, :count).by(-1)
    end
    page.should have_content I18n.t "cms.news_items.destroy.success"
  end

end