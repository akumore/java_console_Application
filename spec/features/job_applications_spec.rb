# encoding: utf-8
require "spec_helper"

describe "JobApplications" do
  monkey_patch_default_url_options

  describe '#new' do
    context 'with no published jobs' do
      before :each do
        Fabricate(:job, title: 'Bauleiter DE')
        visit new_job_application_path
      end

      it 'displays the job application form with default option' do
        expect(current_path).to eq(new_job_application_path)
        expect(page).to have_select('Job', options: ['Initiativbewerbung'])
      end
    end

    context 'with published jobs' do
      before :each do
        Fabricate(:published_job, title: 'Bauleiter DE')
        Fabricate(:published_job, title: 'Bauleiter EN', locale: :en)
      end

      it "displays the job application form with default option and 'Bauleiter DE' option" do
        visit new_job_application_path
        expect(current_path).to eq(new_job_application_path)
        expect(page).to have_css('.new_job_application')
        expect(page).to have_select('Job', options: ['Initiativbewerbung', 'Bauleiter DE'])
      end

      context 'with locale :en' do
        it "displays the job application form with default option and 'Bauleiter EN' option" do
          visit new_job_application_path(locale: :en)
          expect(current_path).to eq(new_job_application_path(locale: :en))
          expect(page).to have_css('.new_job_application')
          expect(page).to have_select('Job', options: ['Unsolicited application', 'Bauleiter EN'])
        end
      end


      describe '#create' do
        before :each do
          visit new_job_application_path
          @attachment = "#{Rails.root}/spec/support/test_files/document.pdf"
          within(".new_job_application") do
            select('Bauleiter DE', from: 'Job')
            fill_in 'Vorname', with: 'Hans'
            fill_in 'Name', with: 'Muster'
            fill_in 'Geboren am', with: '20.05.1986'
            fill_in 'job_application_street', with: 'Musterstrasse 86'
            fill_in 'job_application_city', with: 'Steinhausen'
            fill_in 'job_application_zipcode', with: '6312'
            fill_in 'Telefon', with: '052 255 65 68'
            fill_in 'Mobil', with: '079 123 12 13'
            fill_in 'E-Mail', with: 'hans.muster@domain.com'
            fill_in 'Nachricht', with: 'Sehr geehrte Damen und Herren,\n\nIch will den Job!\n\n VG\nHans'
            attach_file 'Anhang (max. 5 MB)', @attachment
          end
        end

        it 'renders the confirmation message' do
          click_on 'Bewerbung senden'
          page.should have_css('.confirmation')
        end

        it 'displays the given job application information' do
          click_on 'Bewerbung senden'
          expect(page).to have_content('Bauleiter')
          expect(page).to have_content('Hans')
          expect(page).to have_content('Muster')
          expect(page).to have_content('20.05.1986')
          expect(page).to have_content('Musterstrasse 86')
          expect(page).to have_content('Steinhausen')
          expect(page).to have_content('6312')
          expect(page).to have_content('052 255 65 68')
          expect(page).to have_content('079 123 12 13')
          expect(page).to have_content('hans.muster@domain.com')
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
          expect(application.attachment).to be_a(JobApplicationUploader)
          expect(application.attachment.path).to start_with((Rails.root + 'uploads/job_application/attachment/').to_s)
          upload = File.basename(application.attachment.path)
          expect(upload).to eq(File.basename(@attachment))
        end

        it 'attaches the upload to the application using ajax' do
          #, js: true
          pending "Don't know how to spec ajax uploads"
        end

        it "triggers the application notification mailing" do
          lambda {
            click_on 'Bewerbung senden'
          }.should change(ActionMailer::Base.deliveries, :size).by(1)
        end

      end
    end
  end
end
