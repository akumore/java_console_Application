# encoding: utf-8
require 'spec_helper'

describe 'Language Navigation' do
  monkey_patch_default_url_options

  %w(de en fr it).each do |lang|
    it "links to the language version #{lang.upcase}" do
      visit root_path(locale: lang)
      within '.meta-navigation' do
        expect(page).to have_link lang, href: root_path(locale: lang)
      end
    end

    it "links to contacts for #{lang.upcase}" do
      visit root_path(locale: lang)
      within '.meta-navigation' do
        expect(page).to have_link I18n.t('navigation.meta.contact'), href: contact_path(locale: lang)
      end
    end
  end
end


describe "Main Navigation" do
  monkey_patch_default_url_options

  shared_examples_for "All language versions" do |lang|
    it 'links to the list of real estates' do
      visit root_path(locale: lang)
      within '.main-navigation' do
        expect(page).to have_link I18n.t('navigation.main.real_estate'), href: real_estates_path(locale: lang)
      end
    end

    describe "offer subnavigation" do
      it "links to the offers for rent/commercial" do
        visit root_path(locale: lang)
        within all('.sub-navigation')[0] do
          expect(page).to have_link I18n.t('real_estates.search_filter.for_rent'), href: "/#{lang}/real_estates?offer=for_rent&utilization=commercial"
        end
      end

      it "links to the offers for sale/private" do
        visit root_path(locale: lang)
        within all('.sub-navigation')[0] do
          expect(page).to have_link I18n.t('real_estates.search_filter.for_sale'), href: "/#{lang}/real_estates?offer=for_sale&utilization=private"
        end
      end
    end

    it "links to the content page 'jobs'" do
      visit root_path(locale: lang)
      within '.main-navigation' do
        expect(page).to have_link I18n.t('navigation.main.jobs'), href: "/#{lang}/jobs"
      end
    end

    it "links to the sub pages of the content page 'jobs'" do
      jobs_page = Page.create(title: 'Jobs', name: 'jobs', locale: I18n.locale)
      Page.create(title: 'Jobs Subpage', name: 'jobs_subpage', locale: I18n.locale, parent_id: jobs_page.id)

      visit I18n.t('jobs_url')

      # scope within second sub-navigation
      within all('.sub-navigation')[1] do
        expect(page).to have_link('Jobs Subpage', href: "/#{I18n.locale}/jobs_subpage")
      end
    end

    it "shows no sub nav container if no sub pages are present" do
      Page.create(title: 'Jobs', name: 'jobs', locale: I18n.locale)
      visit I18n.t('jobs_url')

      # scope within second sub-navigation
      expect(page).to have_css('.sub-navigation', count: 1)
    end

    it "links to the content page 'company'" do
      visit root_path(locale: lang)
      within '.main-navigation' do
        expect(page).to have_link I18n.t('navigation.main.company'), href: "/#{lang}/company"
      end
    end

    it "links to the news" do
      visit root_path(locale: lang)
      within '.main-navigation' do
        expect(page).to have_link I18n.t('navigation.main.news'), href: news_items_path(locale: lang)
      end
    end

    it "doesn't show links to the reference projects" do
      visit root_path(locale: lang)
      within '.main-navigation' do
        expect(page).to have_link I18n.t('navigation.main.reference_projects'), href: reference_projects_path(locale: lang)
      end
    end
  end


  %w(de fr en it).each do |language|
    context "Language '#{language.upcase}'" do
      it_behaves_like "All language versions", language
    end
  end

end
