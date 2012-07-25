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

    describe "offer subnavigation" do
      it "links to the offers for rent" do
        visit root_path(:locale => lang)
        within '.sub-navigation' do
          page.should have_link I18n.t('real_estates.search_filter.for_rent'), :href => "/#{lang}/real_estates?offer=for_rent&utilization=private"
        end
      end

      it "links to the offers for sale" do
        visit root_path(:locale => lang)
        within '.sub-navigation' do
          page.should have_link I18n.t('real_estates.search_filter.for_sale'), :href => "/#{lang}/real_estates?offer=for_sale&utilization=private"
        end
      end
    end

    it "links to the content page 'jobs'" do
      visit root_path(:locale => lang)
      within '.main-navigation' do
        page.should have_link I18n.t('navigation.main.jobs'), :href => "/#{lang}/jobs"
      end
    end

    it "links to the subchapters of the content page 'jobs'" do
      Page.create(:title => 'Jobs', :name => 'jobs', :locale => I18n.locale) do |jobs_page|
        jobs_page.bricks << Brick::Title.new(:title => 'Brick-Title 1')
        jobs_page.bricks << Brick::Title.new(:title => 'Brick-Title 2')
      end

      visit I18n.t('jobs_url')

      within '.sub-navigation' do
        page.should have_link 'Brick-Title 2', :href => "#{I18n.t('jobs_url')}#brick-title-2"
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
