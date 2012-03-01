# encoding: utf-8
require "spec_helper"

describe "Appointment" do

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

    [:firstname, :lastname, :email, :phone].each do |contact_attr|
      it "shows the #{contact_attr} field" do
        within(".appointment .appointment-contact-details") do
          page.should have_content @contact.send(contact_attr)
        end
      end
    end
  end


  it "can't save because of missing information" do
    visit new_real_estate_appointment_path(@real_estate)
    lambda { click_on 'Kontaktieren Sie mich' }.should_not change(Appointment, :count)
  end

  it "shows validation errors" do
    visit new_real_estate_appointment_path(@real_estate)
    click_on 'Kontaktieren Sie mich'

    %w(Firstname Lastname Email Phone).each do |field|
      within(".alert") { page.should have_content "#{field} muss ausgefüllt werden" }
    end
  end

  it "submits appointment successfully" do
    visit new_real_estate_appointment_path(@real_estate)
    %w(firstname lastname email phone).each do |field|
      fill_in "appointment_#{field}", :with => @contact.send(field)
    end

    lambda { click_on 'Kontaktieren Sie mich' }.should change(@real_estate.appointments, :count).by(1)
    page.should have_content "Vielen Dank für Ihre Kontaktanfrage"
  end

  pending "ajax dingsbums"

end