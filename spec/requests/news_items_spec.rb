# encoding: utf-8

require "spec_helper"

describe "News", :js => true do
  monkey_patch_default_url_options

  before :each do
    20.times { Fabricate(:news_item) }
    3.times { Fabricate(:news_item, :locale => :fr) }
    visit news_items_path
  end

  it 'has an accordion with 10 news items' do
    page.should have_css('.accordion-item', :count => 10)
  end

  it 'loads older news and displays 20 news items' do
    click_link 'Ältere News anzeigen'
    page.should have_css('.accordion-item', :count => 20)
  end

  it 'displays a slideshow of the attached images'
  it 'displays a list of the attached documents'
end