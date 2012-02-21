# encoding: utf-8
require "spec_helper"

describe "JobApplications" do

  describe '#new' do
    before :each do
      Fabricate(:job, :title => 'Bauleiter')
      visit new_job_application_path
    end

    it 'displays the job application form' do
      current_path.should == new_job_application_path
      page.should have_css('.new_job_application')
    end

    describe '#create' do
      before :each do
        @attachment = "#{Rails.root}/spec/support/test_files/document.pdf"
        within(".new_job_application") do
          select('Bauleiter', :from => 'Job')
          fill_in 'Vorname', :with => 'Hans'
          fill_in 'Name', :with => 'Muster'
          fill_in 'Geboren am', :with => '20.05.1986'
          fill_in 'job_application_street', :with => 'Musterstrasse 86'
          fill_in 'job_application_city', :with => 'Steinhausen'
          fill_in 'job_application_zipcode', :with => '6312'
          fill_in 'Telefon', :with => '052 255 65 68'
          fill_in 'Mobil', :with => '079 123 12 13'
          fill_in 'e-Mail Adresse', :with => 'hans.muster@domain.com'
          attach_file 'Attachment', @attachment
        end
      end

      it 'renders the confirmation message' do
        click_on 'Bewerbung senden'
        page.should have_css('.confirmation')
      end

      it 'displays the given job application information' do
        click_on 'Bewerbung senden'
        page.should have_content('Bauleiter')
        page.should have_content('Hans')
        page.should have_content('Muster')
        page.should have_content('20.05.1986')
        page.should have_content('Musterstrasse 86')
        page.should have_content('Steinhausen')
        page.should have_content('6312')
        page.should have_content('052 255 65 68')
        page.should have_content('079 123 12 13')
        page.should have_content('hans.muster@domain.com')
      end

      it 'saves a new job application' do
        lambda {
          click_on 'Bewerbung senden'
        }.should change(JobApplication, :count).by(1)
      end

      it 'attaches the upload to the application' do
        JobApplication.count.should == 0
        click_on 'Bewerbung senden'
        application = JobApplication.first
        application.attachment.should be_a(JobApplicationUploader)
        upload = File.basename(application.attachment.path)
        upload.should == File.basename(@attachment)
      end

      it 'attaches the upload to the application using ajax' do
        #, :js => true
        pending "Don't know how to spec ajax uploads"
      end

    end
  end
end
