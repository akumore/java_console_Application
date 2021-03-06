# encoding: utf-8
require "spec_helper"

describe JobApplicationMailer do

  let :unsolicited_application do
    Fabricate :job_application, :job => nil
  end
  let :dedicated_application do
    Fabricate :job_application, :job => job
  end
  let :job do
    Fabricate :job
  end
  let :application_with_attachment do
    Fabricate :job_application, :attachment => File.open("#{Rails.root}/spec/support/test_files/document.pdf")
  end

  [:unsolicited_application, :dedicated_application, :application_with_attachment].each do |current_application|
    it "sends the #{current_application} notification" do
      lambda {
        JobApplicationMailer.application_notification(send current_application).deliver
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  it 'sends the application mail to Heidi Rohner' do
    mail = JobApplicationMailer.application_notification(unsolicited_application).deliver
    mail.to.should == ['heidi.rohner@alfred-mueller.ch']
  end

  describe 'Subject of application notification' do
    it 'contains the job the application is for' do
      mail = JobApplicationMailer.application_notification(dedicated_application).deliver
      mail.subject.should match job.title
    end

    it 'contains a hint of being an unsolicited application if no job given' do
      mail = JobApplicationMailer.application_notification(unsolicited_application).deliver
      mail.subject.should match 'Initiativbewerbung'
    end
  end

  describe 'Content of application notification' do
    let :dedicated_application_mail do
      JobApplicationMailer.application_notification(dedicated_application).deliver
    end
    let :unsolicited_application_mail do
      JobApplicationMailer.application_notification(unsolicited_application).deliver
    end

    it 'contains the job the application is for' do
      mail = dedicated_application_mail
      mail.body.should match job.title
    end

    it 'highlights itself as unsolicited application if no job given' do
      mail = unsolicited_application_mail
      mail.body.should match "Initiativbewerbung"
    end

    it 'contains the date the application was entered' do
      mail = unsolicited_application_mail
      mail.body.should match I18n.l(unsolicited_application.created_at)
    end

    [:firstname, :lastname].each do |name|
      it "contains the #{name} of the applicant" do
        mail = unsolicited_application_mail
        mail.body.should match unsolicited_application.send(name)
      end
    end

    it 'contains the date of birth of the applicant' do
      mail = unsolicited_application_mail
      mail.body.should match unsolicited_application.birthdate
    end

    it 'contains the address of the applicant' do
      mail = unsolicited_application_mail
      [:street, :zipcode, :city].each do |val|
        mail.body.should match unsolicited_application.send(val)
      end
    end

    it 'contains the phone numbers of the applicant if given' do
      mail = unsolicited_application_mail
      [:phone, :mobile].each do |meth|
        mail.body.should match unsolicited_application.send(meth)
      end

      [:phone, :mobile].each { |meth| dedicated_application.send("#{meth}=", nil) }
      lambda { dedicated_application_mail }.should_not raise_exception
    end

    it 'contains the email address of the applicant' do
      mail = unsolicited_application_mail
      mail.body.should match unsolicited_application.email
    end

    it 'contains the message the applicant has entered' do
      mail = unsolicited_application_mail
      mail.body.should match unsolicited_application.comment
    end

    it 'has the application document attached' do
      mail = JobApplicationMailer.application_notification(application_with_attachment).deliver
      attachment = mail.parts.last
      attachment.content_type.should match "filename=#{unsolicited_application.attachment.filename}"
    end
  end

end
