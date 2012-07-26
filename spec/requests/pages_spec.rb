# encoding: utf-8

require "spec_helper"

describe "Pages" do
  monkey_patch_default_url_options

  describe 'Jobs' do
    before :each do
      [:de, :fr].each do |locale|
        Fabricate :page, :name => 'jobs', :locale => locale,
                  :bricks => [
                    Fabricate.build(:placeholder_brick, :placeholder => 'jobs_openings'),
                    Fabricate.build(:placeholder_brick, :placeholder => 'job_profile_slider')
                  ]
      end

      @unpublished_job = Fabricate :job
      @german_published_job = Fabricate :published_job, :locale => :de
      @french_published_job = Fabricate :published_job, :locale => :fr
    end

    it 'has an accordion with jobs in german' do
      visit I18n.t('jobs_url', :locale => 'de')
      page.should have_css '.jobs .accordion-item', :count => 1
      page.should have_css "#job_#{@german_published_job.id}"
    end

    it 'has an accordion with jobs in french' do
      visit I18n.t('jobs_url', :locale => 'fr')
      page.should have_css '.jobs .accordion-item', :count => 1
      page.should have_css "#job_#{@french_published_job.id}"
    end

    it "has a job profile slider" do
      visit I18n.t('jobs_url', :locale => 'de')
      page.should have_css '.tab-slider', :count => 1
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
          # only email of Christoph Müller is needed here
          page.should have_link 'E-Mail', :href => "mailto:christoph.mueller@alfred-mueller.ch"
        end
      end

      it "shows the managing directors" do
        visit "/de/company"
        within "#managing-board" do
          page.should have_content "Christoph Müller"
          page.should have_content "Michael Müller"
          page.should have_content "Viktor Naumann"
          page.should have_content "Walter Hochreutener"
          page.should have_content "Joe Schmalz"
          page.should have_content "David Spiess"
          page.should have_link 'E-Mail', :href => "mailto:christoph.mueller@alfred-mueller.ch"
          page.should have_link 'E-Mail', :href => "mailto:joe.schmalz@alfred-mueller.ch"
          page.should have_link 'E-Mail', :href => "mailto:michael.mueller@alfred-mueller.ch"
          page.should have_link 'E-Mail', :href => "mailto:david.spiess@alfred-mueller.ch"
          page.should have_link 'E-Mail', :href => "mailto:beat.stocker@alfred-mueller.ch"
          page.should have_link 'E-Mail', :href => "mailto:viktor.naumann@alfred-mueller.ch"
        end
      end

      it "shows a reference projects slider" do
        Fabricate :reference_project
        visit "/de/company"
        page.should have_css("#reference-projects .flex-container .flexslider")
        page.should have_css("#reference-projects ul.slides li")
      end
    end
  end

  describe 'Knowledge Page' do
    before do
      @page = Fabricate(:page, :name => 'knowledge')
      @page.bricks << Fabricate.build(:download_brick)
      visit '/de/knowledge'
    end

    it 'renders a download brick' do
      page.should have_css(".brick.download-brick", :count => 1)
      page.should have_link("#{@page.bricks.first.title}", :href => @page.bricks.first.file.url)
    end
  end
end
