# encoding: utf-8
require 'spec_helper'

describe "Cms::FloorPlans" do
  login_cms_editor

  describe '#new' do
    before do
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'adds a floor_plan' do
      visit new_cms_real_estate_floor_plan_path(@real_estate)

      fill_in 'Titel', :with => 'Der neue Grundriss'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/image.jpg"

      expect {
        click_on 'Grundriss speichern'
      }.to change { @real_estate.reload.floor_plans.count }.by(1)
    end

    it "doesn't add floor_plan if upload has the wrong content type" do
      visit new_cms_real_estate_floor_plan_path(@real_estate)

      fill_in 'Titel', :with => 'This is no floor_plan'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"

      expect {
        click_on 'Grundriss speichern'
        @real_estate.reload
      }.to_not change { @real_estate.floor_plans.count }

      page.should have_content "Datei muss vom Typ jpg, jpeg, png sein"
    end

    it "doesn't create floor_plan without file attached"

  end


  describe "#edit" do
    before do
      @floor_plan = Fabricate.build :media_assets_floor_plan
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :floor_plans => [@floor_plan]
    end

    it 'displays a preview of the floor_plan' do
      visit edit_cms_real_estate_floor_plan_path(@real_estate, @floor_plan)
      page.should have_css('.well img', :count => 1)
    end

    it 'updates the title' do
      visit edit_cms_real_estate_floor_plan_path(@real_estate, @floor_plan)

      fill_in 'Titel', :with => 'The updated Title'
      expect {
        click_on 'Grundriss speichern'
      }.to change { @floor_plan.reload.title }
    end

    it "doesn't update if title is empty" do
      visit edit_cms_real_estate_floor_plan_path(@real_estate, @floor_plan)

      fill_in 'Titel', :with => ''
      expect {
        click_on 'Grundriss speichern'
      }.to_not change { @floor_plan.reload.title }

      page.should have_content "Titel muss ausgefüllt werden"
    end

    it "doesn't update if floor_plan type isn't allowed" do
      visit edit_cms_real_estate_floor_plan_path(@real_estate, @floor_plan)

      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"
      expect {
        click_on 'Grundriss speichern'
      }.to_not change { @floor_plan.reload.updated_at }

      page.should have_content "Datei muss vom Typ jpg, jpeg, png sein"
    end
  end

  describe "#show" do
    before do
      @floor_plan = Fabricate.build :media_assets_floor_plan
      @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :floor_plans => [@floor_plan]
    end

    it 'shows the title' do
      visit cms_real_estate_floor_plan_path(@real_estate, @floor_plan)
      page.should have_content @floor_plan.title
    end

    it 'shows the preview' do
      visit cms_real_estate_floor_plan_path(@real_estate, @floor_plan)
      page.should have_css ".well img"
    end
  end


  describe "#destroy" do
    before do
      @floor_plan = Fabricate.build :media_assets_floor_plan
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :floor_plans => [@floor_plan]
    end

    it 'destroys the floor plan' do
      visit cms_real_estate_media_assets_path(@real_estate)
      expect {
        click_on 'Löschen'
      }.to change { @real_estate.reload.floor_plans.count }.by(-1)
    end
  end
end
