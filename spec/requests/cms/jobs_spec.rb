# encoding: utf-8
require 'spec_helper'

describe "Cms::Jobs" do
  login_cms_user

  describe '#new' do
    before :each do
      visit new_cms_job_path
    end

    it 'opens the create form' do
      current_path.should == new_cms_job_path
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
          @job.offer.should == true
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
        @job.title.should == 'Geänderter Titel'
        @job.text.should == 'Geänderter Text'
        @job.offer.should_not be_true
        @job.job_profile_file.should be_present
      end
    end
  end

end
