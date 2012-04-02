# encoding: utf-8
require 'spec_helper'

describe "Cms::Jobs" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:job) }
      3.times { Fabricate(:job, :locale => :fr) }
      @job = Job.first
      visit cms_jobs_path
    end

    describe 'language tabs' do
      it 'shows a tab for every content language' do
        I18n.available_locales.each do |locale|
          page.should have_link(I18n.t("languages.#{locale}"))
        end
      end

      it 'has the DE tab activated by default' do
        page.should have_css('li.active:contains(DE)')
      end

      it 'selects the tab according to the content langauge' do
        visit cms_jobs_path(:content_language => :fr)
        page.should have_css('li.active:contains(FR)')
      end
    end

    it "shows the list of jobs for the current content locale" do
      page.should have_selector('table tr', :count => Job.where(:locale => :de).count+1)
    end

    it "takes me to the edit page of a job" do
      within("#job_#{@job.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_job_path(@job)
    end

    it "takes me to the page for creating a new job" do
      page.click_link 'Neuen Job erstellen'
      current_path.should == new_cms_job_path
    end
  end

  describe '#new' do
    before :each do
      visit new_cms_job_path(:content_locale => :fr)
    end

    it 'opens the create form' do
      current_path.should == new_cms_job_path
    end

    it 'informs of the current content locale in the title' do
      page.should have_content('Neuen Job in Französisch anlegen')
    end

    it 'prefills the selected language' do
      page.should have_css('input#job_locale[value=fr]')
    end

    context 'a valid Job' do
      before :each do
        within(".new_job") do
          fill_in 'Titel', :with => 'Ein Job als Baumeister'
          fill_in 'Text', :with => '## Markdown Text'
          check 'Veröffentlichen?'
          attach_file 'Stellenprofil', "#{Rails.root}/spec/support/test_files/document.pdf"
        end
      end

      it 'save a new Job' do
        lambda do
          click_on 'Job erstellen'
        end.should change(Job, :count).from(0).to(1)
      end

      context '#create' do
        before :each do
          click_on 'Job erstellen'
          @job = Job.last
        end

        it 'has saved the provided attributes' do
          @job.title.should == 'Ein Job als Baumeister'
          @job.text.should == '## Markdown Text'
          @job.is_published.should == true
          @job.job_profile_file.should be_present
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @job = Fabricate(:published_job)
      visit edit_cms_job_path(@job)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_job_path(@job)
    end

    context '#update' do
      before :each do
        within(".edit_job") do
          fill_in 'Titel', :with => 'Geänderter Titel'
          fill_in 'Text', :with => 'Geänderter Text'
          uncheck 'Veröffentlichen'
        end

        click_on 'Job speichern'
      end

      it 'has updated the edited attributes' do
        @job.reload
        @job.title.should == 'Geänderter Titel'
        @job.text.should == 'Geänderter Text'
        @job.is_published.should_not be_true
        @job.job_profile_file.should be_present
      end
    end
  end

  describe '#destroy' do
    before :each do
      @job = Fabricate(:job)
      visit cms_jobs_path
    end

    it 'deletes the job' do
      lambda {
        within("#job_#{@job.id}") do
          click_link 'Löschen'
        end
      }.should change(Job, :count).by(-1)
    end
  end

end
