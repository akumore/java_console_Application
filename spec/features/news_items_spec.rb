# encoding: utf-8

require "spec_helper"

describe "News", js: true do
  monkey_patch_default_url_options

  describe 'list view' do
    before :each do
      20.times { Fabricate(:news_item) }
      3.times { Fabricate(:news_item, locale: :fr) }
      visit news_items_path
    end

    it 'has a button nav with year of the news' do
      expect(page).to have_css('.button-navigation')
      expect(page.find(".button-navigation li").text).to eq(Date.today.year.to_s)
    end

    it 'has an accordion with 20 news items' do
      expect(page).to have_css('.accordion-item', count: 20)
    end

    it 'should not have laod more link' do
      expect(page).to_not have_css('.load-more')
    end

    it 'shows auto discovery rss link' do
      expect(page).to have_xpath("//link[contains(@href, 'news_items.xml')]")
    end
  end


  describe 'detail view' do
    before do
      # Switching driver because of a bug visiting links with anchors
      Capybara.javascript_driver=:selenium
    end

    after do
      Capybara.javascript_driver=:webkit
    end

    #
    # The following tests use the selenium javascript driver
    # because capybara_webkit seems to timeout on anchors in URLs
    # https://github.com/thoughtbot/capybara-webkit/issues/52
    #
    let :news_item do
      Fabricate(:news_item)
    end

    context 'linking to a specific news item' do
      it 'opens the first news item by default' do
        news_item
        visit news_items_path
        expect(page).to have_css('.accordion-item.open', count: 1)
      end

      it 'opens the specified news item in the accordion' do
        visit news_items_path(anchor: "news_item_#{news_item.id}")
        expect(page).to have_css("#news_item_#{news_item.id}.accordion-item.open")
      end
    end

    context 'with images' do
      it 'displays a slideshow of the attached images' do
        news_item.images << Fabricate.build(:news_item_image)
        news_item.images << Fabricate.build(:news_item_image)
        news_item.images << Fabricate.build(:news_item_image)

        visit news_items_path(anchor: "news_item_#{news_item.id}")

        expect(page).to have_css("#news_item_#{news_item.id} .flexslider")
        expect(page).to have_css("#news_item_#{news_item.id} .flexslider .slides li:not(.clone)", count: 3)
      end
    end

    context 'with documents' do
      it 'displays a list of the attached documents' do
        news_item.documents << Fabricate.build(:news_item_document)
        news_item.documents << Fabricate.build(:news_item_document)
        news_item.documents << Fabricate.build(:news_item_document)

        visit news_items_path(anchor: "news_item_#{news_item.id}")

        expect(page).to have_css("#news_item_#{news_item.id} a.icon-document", count: 3)

        news_item.documents.each do |doc|
          expect(page).to have_link(File.basename(doc.file.path))
        end
      end
    end
  end
end
