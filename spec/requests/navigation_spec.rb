# encoding: utf-8
require 'spec_helper'

describe 'Language Navigation' do

  %w(de en fr it).each do |locale|
    it "links to the language version #{locale.upcase}" do
      visit root_path :locale => locale
      within '.meta-navigation' do
        page.should have_link locale, :href => root_path(:locale => locale)
      end
    end

    it "links to contacts for #{locale.upcase}" do
      visit root_path :locale => locale
      within '.meta-navigation' do
        page.should have_link I18n.t('navigation.meta.contact'), :href => contact_path(:locale => locale)
      end
    end
  end

end


describe "Main Navigation" do

  shared_examples_for "All language versions" do |locale|
    it 'links to the list of real estates' do
      visit root_path :locale => locale
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.real_estate'), :href => real_estates_path(:locale => locale)
      end
    end

    it "links to the content page 'jobs'" do
      visit root_path :locale => locale
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.jobs'), :href => "/#{locale}/jobs"
      end
    end

    it "links to the content page 'company'" do
      visit root_path :locale => locale
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.company'), :href => "/#{locale}/company"
      end
    end

    it "links to the news" do
      visit root_path :locale => locale
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.news'), :href => news_items_path(:locale => locale)
      end
    end
  end


  shared_examples_for "All languages but 'DE'" do |locale|
    it "has no link to the content page 'knowledge'" do
      visit root_path :locale => locale
      within '.main-navigation' do
        page.should_not have_link I18n.t('navigation.main.knowledge'), :href => "/#{locale}/knowledge"
      end
    end
  end


  context "Language 'DE'" do
    it_behaves_like "All language versions", 'de'

    it "links to the content page 'knowledge'" do
      visit root_path
      within '.main-navigation' do
        page.should have_link 'Wissenswertes', :href => "/de/knowledge"
      end
    end
  end


  %w(fr en it).each do |locale|
    context "Language '#{locale.upcase}'" do
      it_behaves_like "All language versions", locale
      it_behaves_like "All languages but 'DE'", locale
    end
  end

end