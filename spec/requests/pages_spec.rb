# encoding: utf-8

require "spec_helper"

describe "Pages" do

  describe 'Jobs' do
    before :each do
      @page = Fabricate(:page, :name => 'jobs')
      @page.bricks << Fabricate.build(:placeholder_brick, :placeholder => 'jobs_openings')

      Fabricate(:job) # create unpublished job
      3.times { Fabricate(:published_job) }
      3.times { Fabricate(:published_job, :locale => :fr) }
      visit I18n.t('jobs_url')
    end

    it 'has an accordion with 3 jobs in german' do
      page.should have_css('.jobs .accordion-item', :count => 3)
    end
  end


  describe "Company Page" do

    before do
      @brick = Fabricate.build(:placeholder_brick, :placeholder => 'company_header')
      @page = Fabricate(:page, :name => 'company', :bricks => [@brick])
    end

    it "has a tab slider" do
      visit "/de/company"
      page.should have_css "#head-of-alfred-mueller-gallery"
    end

    describe "The tab slider" do
      it "shows the board of directors" do
        visit "/de/company"
        within "#board-of-directors" do
          page.should have_content "Christoph Müller"
          page.should have_content "Viktor Naumann"
          page.should have_content "Dr. Erich Rüegg"
        end
      end

      it "shows the managing directors"
      it "shows reference projects"
    end

  end
end
