# encoding: utf-8
require 'spec_helper'

describe "Cms News Items Administration" do
  login_cms_user

  describe "#new" do
    it "creates a news item" do
      visit new_cms_news_item_path

      fill_in 'news_item_title', :with => 'Invasion vom Mars'
      fill_in 'news_item_teaser', :with => 'Visit me at the page footer'
      fill_in 'news_item_content', :with => 'Das ist ja kaum zu glauben!'

      expect { click_button 'News erstellen' }.should change(NewsItem, :count).by(1)
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
      visit new_cms_news_item_path :locale => 'it'

      fill_in 'news_item_title', :with => 'it: Invasion vom Mars'
      fill_in 'news_item_teaser', :with => 'it: Visit me at the page footer'
      fill_in 'news_item_content', :with => 'it: Das ist ja kaum zu glauben!'

      expect { click_button 'News erstellen' }.should change(NewsItem, :count).by(1)
      NewsItem.where(:title => 'it: Invasion vom Mars').first.locale.should == 'it'
    end

    it 'adds images to the news item'
    it 'adds documents to the news item'
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

    it "doesn't switch the news items language"

    it 'adds images to the news item'
    it 'removes images from the news item'
    it 'adds documents to the news item'
    it 'removes documents from the news item'
  end


  describe "order attached images and documents" do
    it 'updates the order position of the image'
    it 'updates the order position of the document'
  end

end