# encoding: utf-8

require 'spec_helper'

describe ReferenceProject do
  monkey_patch_default_url_options

  before do
    Fabricate(:page, title: 'Referenzen', name: 'reference_projects')
  end

  describe 'shows the reference projects list' do
    before :each do
      visit reference_projects_path
    end

    context 'with 5 existing reference projects' do
      before do
        5.times do
          Fabricate(:reference_project, offer: Offer::SALE, utilization: Utilization::LIVING, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ])
        end
        visit reference_projects_path
      end

      it 'shows the projects container' do
        page.should have_css('.reference-projects-container')
      end

      context 'without clicking on load more button' do
        it 'has 4 projects' do
          page.should have_css('.reference-projects-container .reference-project', count: 4)
        end
      end

      context 'with clicking on load more button', js: true do
        before do
          click_link 'Mehr anzeigen'
        end

        it 'has 5 projects' do
          page.should have_css('.reference-projects-container .reference-project', count: 5)
        end
      end
    end

    context 'with non existing reference projects' do
      it 'shows no projects container' do
        page.should_not have_css('.reference-projects-container')
      end

      it 'has no projects' do
        page.should_not have_css('.reference-projects-container .reference-project')
      end

      it 'does not show the load more link' do
        page.should_not have_css('.reference-projects-container .load-more')
      end
    end
  end

  describe 'section tab navigation' do
    before do
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::RESIDENTIAL_BUILDING)
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::RESIDENTIAL_COMMERCIAL_BUILDING)
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::BUSINESS_BUILDING)
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::TRADE_INDUSTRIAL_BUILDING)
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::SPECIAL_BUILDING)
      Fabricate(:reference_project, displayed_on: [ ReferenceProject::REFERENCE_PROJECT_PAGE ], section: ReferenceProjectSection::REBUILDING)
      visit reference_projects_path
    end

    it 'shows the tab navigation' do
      page.should have_css('.button-navigation-container')
    end

    it "shows tab navigation for all sections" do
      page.should have_css('.button-navigation li', count: 6)
    end
  end
end
