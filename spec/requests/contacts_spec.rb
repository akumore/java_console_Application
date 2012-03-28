# encoding: utf-8
require "spec_helper"

describe "Contacts" do
  monkey_patch_default_url_options

  describe '#new' do
    before :each do
      visit new_contact_path
    end

    it 'displays the contact form' do
      current_path.should == new_contact_path
      page.should have_css('.new_contact')
    end

    describe '#create' do
      before :each do
        within(".new_contact") do
          fill_in 'Name', :with => 'Bruno Meier'
          fill_in 'contact_street', :with => 'Musterstrasse 86'
          fill_in 'contact_city', :with => 'Steinhausen'
          fill_in 'contact_zip', :with => '6312'
          fill_in 'e-Mail Adresse', :with => 'bruno.meier@domain.com'
          fill_in 'Nachricht', :with => 'Sehr geehrte Damen und Herren,\n\nKontaktieren Sie mich!\n\n VG\nBruno'
        end
      end

      it 'renders the confirmation message' do
        click_on 'Kontaktanfrage senden'
        page.should have_css('.confirmation')
      end

      it 'displays the given contact form information' do
        click_on 'Kontaktanfrage senden'
        page.should have_content('Bruno Meier')
        page.should have_content('Musterstrasse 86')
        page.should have_content('Steinhausen')
        page.should have_content('6312')
        page.should have_content('bruno.meier@domain.com')
      end

      it 'saves a new contact' do
        lambda {
          click_on 'Kontaktanfrage senden'
        }.should change(Contact, :count).by(1)
      end

      it "triggers the contact notification mailing" do
        pending 'needs to be implemented'
        lambda {
          click_on 'Kontaktanfrage senden'
        }.should change(ActionMailer::Base.deliveries, :size).by(1)
      end

    end
  end
end
