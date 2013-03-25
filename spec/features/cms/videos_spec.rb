# encoding: utf-8
require 'spec_helper'

describe "Cms::Videos" do
  login_cms_editor

  describe '#new' do
    before do
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'adds a video' do
      visit new_cms_real_estate_video_path(@real_estate)

      fill_in 'Titel', :with => 'Das neue Video'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/video.mp4"

      expect {
        click_on 'Video speichern'
      }.should change { @real_estate.reload.videos.count }.by(1)
    end

    it "doesn't add video if upload has the wrong content type" do
      visit new_cms_real_estate_video_path(@real_estate)

      fill_in 'Titel', :with => 'This is no video'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"

      expect {
        click_on 'Video speichern'
      }.should_not change { @real_estate.reload.videos.count }

      page.should have_content "Datei muss vom Typ mp4, m4v, mov sein"
    end

    it "doesn't create video without file attached"

  end


  describe "#edit" do
    before do
      @video = Fabricate.build :media_assets_video
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :videos => [@video]
    end

    it 'displays a preview of the video' do
      visit edit_cms_real_estate_video_path(@real_estate, @video)
      page.should have_css('.well video', :count => 1)
    end

    it 'updates the title' do
      visit edit_cms_real_estate_video_path(@real_estate, @video)

      fill_in 'Titel', :with => 'The updated Title'
      expect {
        click_on 'Video speichern'
      }.should change { @video.reload.title }
    end

    it "doesn't update if title is empty" do
      visit edit_cms_real_estate_video_path(@real_estate, @video)

      fill_in 'Titel', :with => ''
      expect {
        click_on 'Video speichern'
      }.should_not change { @video.reload.title }

      page.should have_content "Titel muss ausgefüllt werden"
    end

    it "doesn't update if video type isn't allowed" do
      visit edit_cms_real_estate_video_path(@real_estate, @video)

      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"
      expect {
        click_on 'Video speichern'
      }.should_not change { @video.reload.updated_at }

      page.should have_content "Datei muss vom Typ mp4, m4v, mov sein"
    end
  end


  describe "#show" do
    before do
      @video = Fabricate.build :media_assets_video
      @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :videos => [@video]
    end

    it 'shows the title' do
      visit cms_real_estate_video_path(@real_estate, @video)
      page.should have_content @video.title
    end

    it 'shows the preview' do
      visit cms_real_estate_video_path(@real_estate, @video)
      page.should have_css ".well video"
    end
  end


  describe "#destroy" do
    before do
      @video = Fabricate.build :media_assets_video
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :videos => [@video]
    end

    it 'destroys the video' do
      visit cms_real_estate_media_assets_path(@real_estate)
      expect {
        click_on 'Löschen'
      }.should change { @real_estate.reload.videos.count }.by(-1)
    end
  end
end
