# encoding: utf-8
require "spec_helper"

describe "HandoutOrder" do
  monkey_patch_default_url_options

  before do
    @contact = Fabricate(:employee)
    @real_estate = Fabricate(:real_estate,
                             :contact => @contact,
                             :category => Fabricate(:category),
                             :utilization => Utilization::WORKING,
                             :order_handout => true
                            )
  end

  it "displays the handout order form" do
    visit new_real_estate_handout_order_path(@real_estate)
    page.should have_css(".handout-order .contact-form")
  end

  describe "Showing contact information within handout order slide" do
    before do
      visit new_real_estate_handout_order_path(@real_estate)
    end

    %w(firstname lastname phone).each do |contact_attr|
      it "shows the #{contact_attr} field" do
        within(".handout-order .handout-order-contact-details") do
          page.should have_content @contact.send(contact_attr)
        end
      end

      it 'shows the email link' do
        within(".handout-order") do
          page.should have_link('E-Mail', :href => "mailto:#{@contact.email}")
        end
      end
    end
  end


  it "can't save because of missing information" do
    visit new_real_estate_handout_order_path(@real_estate)
    lambda { click_button I18n.t("handout_orders.form.submit") }.should_not change(HandoutOrder, :count)
  end

  it "shows validation errors" do
    visit new_real_estate_handout_order_path(@real_estate)
    click_button I18n.t("handout_orders.form.submit")

    page.should have_content('Bitte überprüfen Sie ihre Eingaben:')
  end

  it "submits handout order successfully" do
    visit new_real_estate_handout_order_path(@real_estate)
    %w(company firstname lastname email phone street zipcode city).each do |field|
      fill_in "handout_order_#{field}", :with => field
    end

    lambda { click_button I18n.t("handout_orders.form.submit") }.should change(HandoutOrder, :count).by(1)
    page.should have_content I18n.t("handout_orders.confirmation.thanks")
  end

  pending "spec creation of handout order, the AJAX way..."

end
