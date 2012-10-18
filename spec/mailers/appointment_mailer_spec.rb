# encoding: utf-8
require "spec_helper"

describe AppointmentMailer do
  monkey_patch_default_url_options

  let :real_estate do
    Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :reference => Fabricate.build(:reference),
      :contact => Fabricate(:employee)
    )
  end

  let :appointment do
    Fabricate :appointment, :real_estate => real_estate
  end

  let :appointment_mail do
    AppointmentMailer.appointment_notification(appointment).deliver
  end

  it "sends the appointment notification" do
    lambda {
      AppointmentMailer.appointment_notification(appointment).deliver
    }.should change(ActionMailer::Base.deliveries, :size).by(1)
  end

  it 'sends the application mail to the real estates assigned contact person' do
    appointment_mail.to.should == [appointment.real_estate.contact.email]
  end

  it 'sets the reply address to the person requesting the appointment' do
    appointment_mail.reply_to.should == [appointment.email]
  end

  describe 'Subject of the appointment notification' do
    it 'contains the real estate\'s title' do
      appointment_mail.subject.should match appointment.real_estate.title
    end
  end

  I18n.available_locales.each do |locale|
    describe "Content of application notification for locale '#{locale}'" do
      before do
        I18n.locale = locale
      end

      after do
        I18n.locale = :de
      end

      it 'contains the title of the real estate the appointment is for' do
        appointment_mail.body.should match appointment.real_estate.title
      end

      it 'contains a link to the real estate it is for' do
        appointment_mail.body.should match(real_estate_url(appointment.real_estate))
      end

      it 'contains the date the appointment was entered' do
        appointment_mail.body.should match I18n.l(appointment.created_at, :locale => :de)
      end

      [:firstname, :lastname, :email, :phone, :street, :zipcode, :city].each do |name|
        it "contains the #{name} of the applicant" do
          appointment_mail.body.should match appointment.send(name)
        end
      end
    end
  end
end
