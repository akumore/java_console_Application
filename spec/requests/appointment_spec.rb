# encoding: utf-8
require "spec_helper"

describe "Appointment" do
  monkey_patch_default_url_options

  before do
    @contact = Fabricate(:employee)
    @real_estate = Fabricate :real_estate, :contact => @contact, :category => Fabricate(:category)
  end

  it "displays the appointment form" do
    visit new_real_estate_appointment_path(@real_estate)
    page.should have_css(".appointment .contact-form")
  end

  describe "Showing contact information within appointment slide" do
    before do
      visit new_real_estate_appointment_path(@real_estate)
    end

    %w(firstname lastname phone).each do |contact_attr|
      it "shows the #{contact_attr} field" do
        within(".appointment .appointment-contact-details") do
          page.should have_content @contact.send(contact_attr)
        end
      end

      it 'shows the email link' do
        within(".appointment") do
          page.should have_link('E-Mail', :href => "mailto:#{@contact.email}")
        end
      end
    end
  end


  it "can't save because of missing information" do
    visit new_real_estate_appointment_path(@real_estate)
    lambda { click_button I18n.t("appointments.form.submit") }.should_not change(Appointment, :count)
  end

  it "shows validation errors" do
    visit new_real_estate_appointment_path(@real_estate)
    click_button I18n.t("appointments.form.submit")

    page.should have_content('Bitte überprüfen Sie ihre Eingaben:')
  end

  it "submits appointment successfully" do
    visit new_real_estate_appointment_path(@real_estate)
    %w(firstname lastname email phone street zipcode city).each do |field|
      fill_in "appointment_#{field}", :with => field
    end

    lambda { click_button I18n.t("appointments.form.submit") }.should change(@real_estate.appointments, :count).by(1)
    page.should have_content I18n.t("appointments.confirmation.thanks")
  end

  pending "spec creation of appointments, the AJAX way..."

end
