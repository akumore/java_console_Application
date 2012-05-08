# encoding: utf-8
require 'spec_helper'

describe 'Language Navigation' do
  monkey_patch_default_url_options

  %w(de en fr it).each do |lang|
    it "links to the language version #{lang.upcase}" do
      visit root_path(:locale => lang)
      within '.meta-navigation' do
        page.should have_link lang, :href => root_path(:locale => lang)
      end
    end

    it "links to contacts for #{lang.upcase}" do
      visit root_path(:locale => lang)
      within '.meta-navigation' do
        page.should have_link I18n.t('navigation.meta.contact'), :href => contact_path(:locale => lang)
      end
    end
  end

end


describe "Main Navigation" do
  monkey_patch_default_url_options

  shared_examples_for "All language versions" do |lang|
    it 'links to the list of real estates' do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.real_estate'), :href => real_estates_path(:locale => lang)
      end
    end

    it "links to the content page 'jobs'" do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.jobs'), :href => "/#{lang}/jobs"
      end
    end

    it "links to the content page 'company'" do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.company'), :href => "/#{lang}/company"
      end
    end

    it "links to the news" do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.news'), :href => news_items_path(:locale => lang)
      end
    end

    it "links to the content page 'knowledge'" do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.knowledge'), :href => "/#{lang}/knowledge"
      end
    end
  end


  %w(de fr en it).each do |language|
    context "Language '#{language.upcase}'" do
      it_behaves_like "All language versions", language
    end
  end

end