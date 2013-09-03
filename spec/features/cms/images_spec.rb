# encoding: utf-8
require 'spec_helper'

describe "Cms::Images" do
  login_cms_editor

  describe '#new' do
    before do
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'adds an image' do
      visit new_cms_real_estate_image_path(@real_estate)

      fill_in 'Titel', :with => 'Das neue Bild'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/image.jpg"

      expect {
        click_on 'Bild speichern'
      }.should change { @real_estate.reload.images.count }.by(1)
    end

    it "doesn't add image if upload has the wrong content type" do
      visit new_cms_real_estate_image_path(@real_estate)

      fill_in 'Titel', :with => 'This is no image'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"

      expect {
        click_on 'Bild speichern'
      }.should_not change { @real_estate.reload.images.count }

      page.should have_content "Datei muss vom Typ jpg, jpeg, png sein"
    end

    it "doesn't create image without file attached"

  end


  describe "#edit" do
    before do
      @image = Fabricate.build :media_assets_image
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :images => [@image]
    end

    it 'displays a preview of the image' do
      visit edit_cms_real_estate_image_path(@real_estate, @image)
      page.should have_css('.well img', :count => 1)
    end

    it 'makes the image primary' do
      visit edit_cms_real_estate_image_path(@real_estate, @image)

      check 'Hauptbild'
      expect {
        click_on 'Bild speichern'
      }.should change { @image.reload.is_primary }
    end

    it 'updates the title' do
      visit edit_cms_real_estate_image_path(@real_estate, @image)

      fill_in 'Titel', :with => 'The updated Title'
      expect {
        click_on 'Bild speichern'
      }.should change { @image.reload.title }
    end

    it "doesn't update if title is empty" do
      visit edit_cms_real_estate_image_path(@real_estate, @image)

      fill_in 'Titel', :with => ''
      expect {
        click_on 'Bild speichern'
      }.to_not change { @image.reload.title }

      page.should have_content "Titel muss ausgefüllt werden"
    end

    it "doesn't update if image type isn't allowed" do
      visit edit_cms_real_estate_image_path(@real_estate, @image)

      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"
      expect {
        click_on 'Bild speichern'
      }.should_not change { @image.reload.updated_at }

      page.should have_content "Datei muss vom Typ jpg, jpeg, png sein"
    end
  end


  describe "#show" do
    before do
      @image = Fabricate.build :media_assets_image
      @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :images => [@image]
    end

    it 'shows the title' do
      visit cms_real_estate_image_path(@real_estate, @image)
      page.should have_content @image.title
    end

    it 'shows the preview' do
      visit cms_real_estate_image_path(@real_estate, @image)
      page.should have_css ".well img"
    end
  end


  describe "#destroy" do
    before do
      @image = Fabricate.build :media_assets_image
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :images => [@image]
    end

    it 'destroys the image' do
      visit cms_real_estate_media_assets_path(@real_estate)
      expect {
        click_on 'Löschen'
      }.should change { @real_estate.reload.images.count }.by(-1)
    end
  end
end
