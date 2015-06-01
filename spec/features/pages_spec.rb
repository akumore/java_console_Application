# encoding: utf-8

require "spec_helper"

describe "Pages" do
  monkey_patch_default_url_options

  describe 'Jobs' do
    before :each do
      [:de, :fr].each do |locale|
        Fabricate :page, name: 'jobs', locale: locale, seo_title: 'Jobs - Page Title', seo_description: 'Jobs - SEO Description',
                  bricks: [
                    Fabricate.build(:placeholder_brick, placeholder: 'jobs_openings'),
                    Fabricate.build(:placeholder_brick, placeholder: 'job_profile_slider')
                  ]
      end

      @unpublished_job = Fabricate :job
      @german_published_job = Fabricate :published_job, locale: :de
      @french_published_job = Fabricate :published_job, locale: :fr
    end

    it 'has an accordion with jobs in german' do
      visit I18n.t('jobs_url', locale: 'de')
      expect(page).to have_css '.jobs .accordion__item', count: 1
      expect(page).to have_css "#job_#{@german_published_job.id}"
    end

    it 'has an accordion with jobs in french' do
      visit I18n.t('jobs_url', locale: 'fr')
      expect(page).to have_css '.jobs .accordion__item', count: 1
      expect(page).to have_css "#job_#{@french_published_job.id}"
    end

    it "has a job profile slider" do
      visit I18n.t('jobs_url', locale: 'de')
      expect(page).to have_css '.tab-slider', count: 1
    end

    it 'has a valid page title' do
      visit I18n.t('jobs_url', locale: 'de')
      expect(first('title').native.text).to eq "Jobs - Page Title"
    end

    it 'has a valid seo description' do
      visit I18n.t('jobs_url', locale: 'de')
      expect(page).to have_css("meta[content='Jobs - SEO Description']")
    end
  end


  describe "Company Page" do
    before do
      @brick = Fabricate.build(:placeholder_brick, placeholder: 'company_header')
      @page = Fabricate(:page, name: 'company', bricks: [@brick])
    end

    it "has a tab slider" do
      visit "/de/company"
      expect(page).to have_css "#head-of-alfred-mueller-gallery"
    end

    describe "The tab slider" do
      it "shows the board of directors" do
        visit "/de/company"
        within "#board-of-directors" do
          expect(page).to have_content "Christoph Müller"
          expect(page).to have_content "Viktor Naumann"
          expect(page).to have_content "Erich Rüegg"
          # only email of Christoph Müller is needed here
          expect(page).to have_link 'E-Mail', href: "mailto:christoph.mueller@alfred-mueller.ch"
        end
      end

      it "shows the managing directors" do
        visit "/de/company"
        within "#managing-board" do
          expect(page).to have_content "David Hossli"
          expect(page).to have_content "Michael Müller"
          expect(page).to have_content "Walter Hochreutener"
          expect(page).to have_content "Joe Schmalz"
          expect(page).to_not have_content "David Spiess"
          expect(page).to have_link 'E-Mail', href: "mailto:david.hossli@alfred-mueller.ch"
          expect(page).to have_link 'E-Mail', href: "mailto:joe.schmalz@alfred-mueller.ch"
          expect(page).to have_link 'E-Mail', href: "mailto:michael.mueller@alfred-mueller.ch"
          expect(page).to_not have_link 'E-Mail', href: "mailto:david.spiess@alfred-mueller.ch"
          expect(page).to have_link 'E-Mail', href: "mailto:beat.stocker@alfred-mueller.ch"
        end
      end
    end
  end

  describe 'Knowledge Page' do
    before do
      @page = Fabricate(:page, name: 'knowledge')
      @page.bricks << Fabricate.build(:download_brick)
      visit '/de/knowledge'
    end

    it 'renders a download brick' do
      expect(page).to have_css(".brick.download-brick", count: 1)
      expect(page).to have_link("#{@page.bricks.first.title}", href: @page.bricks.first.file.url)
    end
  end
end
