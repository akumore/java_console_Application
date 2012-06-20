# encoding: utf-8
require "spec_helper"

describe ContactMailer do
  monkey_patch_default_url_options

  let :contact do
    Fabricate :contact
  end

  let :contact_mail do
    ContactMailer.contact_notification(contact).deliver
  end

  it "sends the contact notification" do
    lambda {
      ContactMailer.contact_notification(contact).deliver
    }.should change(ActionMailer::Base.deliveries, :size).by(1)
  end

  it 'sends the application mail to Alfred Müller' do
    contact_mail.to.should == ['mail@alfred-mueller.ch']
  end

  it 'sets the reply address to the person requesting the contact' do
    contact_mail.reply_to.should == [contact.email]
  end

  describe 'Subject of the contact notification' do
    it 'contains the name of the person initiating the contact' do
      contact_mail.subject.should match contact.firstname
    end
  end

  describe 'Content of application notification' do
    it 'contains the date the contact was entered' do
      contact_mail.body.should match I18n.l(contact.created_at)
    end

    [:firstname, :lastname, :street, :zip, :city, :email, :message].each do |name|
      it "contains the #{name} of the applicant" do
        contact_mail.body.should match contact.send(name)
      end
    end
  end
end
