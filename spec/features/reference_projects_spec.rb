# encoding: utf-8

require 'spec_helper'

describe ReferenceProject do
  monkey_patch_default_url_options

  describe 'shows the reference projects list' do
    before :each do
      visit reference_projects_path
    end

    context 'with 5 existing reference projects' do
      before do
        5.times do
          Fabricate(:reference_project, :offer => Offer::SALE, :utilization => Utilization::LIVING)
        end
        visit reference_projects_path
      end

      it 'shows the projects container' do
        page.should have_css('.reference-projects-container')
      end

      context 'without clicking on load more button' do
        it 'has 4 projects' do
          page.should have_css('.reference-projects-container .reference-project', :count => 4)
        end
      end

      context 'with clicking on load more button', :js => true do
        before do
          click_link 'Mehr anzeigen'
        end

        it 'has 5 projects' do
          page.should have_css('.reference-projects-container .reference-project', :count => 5)
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
      Fabricate(:reference_project, :section => ReferenceProjectSection::RESIDENTIAL_BUILDING)
      Fabricate(:reference_project, :section => ReferenceProjectSection::BUSINESS_BUILDING)
      Fabricate(:reference_project, :section => ReferenceProjectSection::PUBLIC_BUILDING)
      visit reference_projects_path
    end

    it 'shows the tab navigation' do
      page.should have_css('.search-filter-container')
    end

    it "shows three tabs for 'residential buildings', 'business buildings' and 'public buildings'" do
      page.should have_css('.offer-tabs li', :count => 3)
    end
  end
end
