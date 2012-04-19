# encoding: utf-8
require 'spec_helper'

describe "Cms::MediaAssets" do
  login_cms_user
  create_category_tree

  before :each do
    @real_estate = Fabricate(:real_estate,
      :category => Category.last,
      :reference => Fabricate.build(:reference)
    )

    @real_estate.media_assets << Fabricate.build(:media_asset_image, :real_estate => @real_estate)
    @real_estate.media_assets << Fabricate.build(:media_asset_video, :real_estate => @real_estate)
    @real_estate.media_assets << Fabricate.build(:media_asset_document, :real_estate => @real_estate)

    visit edit_cms_real_estate_path(@real_estate)
    click_on 'Bilder & Dokumente'
  end

  describe '#index' do
    it 'has a link to create a new image' do
      page.should have_link('Bild erfassen')
    end

    it 'has a link to create a new video' do
      page.should have_link('Video erfassen')
    end

    it 'has a link to create a new document' do
      page.should have_link('Dokument erfassen')
    end

    it 'has 3 media assets in the list' do
      @real_estate.reload
      @real_estate.media_assets.count.should == 3
    end

    it 'is sortable via drag and drop'
  end

  describe '#new image' do
    before :each do
      click_on 'Bild erfassen'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_image_path(@real_estate)
    end

    context 'adding an image' do

      before :each do
        within '.new_media_asset' do
          fill_in 'Titel', :with => 'Das neue Bild'
          check 'Hauptbild'
          attach_file 'Datei', "#{Rails.root}/spec/support/test_files/image.jpg"
        end
        click_on 'Bild speichern'
      end

      it 'renders the edit form' do
        @real_estate.reload
        current_path.should == edit_cms_real_estate_media_asset_path(@real_estate, @real_estate.media_assets.last)
      end

      it 'can be checked as primary visual' do
        page.should have_css('#media_asset_is_primary[type=checkbox]')
      end

      it 'can be checked as floorplan' do
        page.should have_css('#media_asset_is_floorplan[type=checkbox]')
      end

      it 'displays a preview of the image' do
        page.should have_css('.well img', :count => 1)
      end

      it 'saves the provided attributes' do
        @real_estate.reload
        image = @real_estate.media_assets.last
        image.title.should == 'Das neue Bild'
        image.is_primary.should be_true
        image.media_type.should == MediaAsset::IMAGE
      end
    end
  end

  describe '#new video' do
    before :each do
      click_on 'Video erfassen'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_video_path(@real_estate)
    end

    context 'adding a video' do

      before :each do
        within '.new_media_asset' do
          fill_in 'Titel', :with => 'Das neue Video'
          attach_file 'Datei', "#{Rails.root}/spec/support/test_files/video.mp4"
        end
        click_on 'Video speichern'
      end

      it 'renders the edit form' do
        @real_estate.reload
        current_path.should == edit_cms_real_estate_media_asset_path(@real_estate, @real_estate.media_assets.last)
      end

      it 'can be checked as primary visual' do
        page.should have_css('#media_asset_is_primary[type=checkbox]')
      end

      it 'cannot be checked as floorplan' do
        page.should_not have_css('#media_asset_is_floorplan[type=checkbox]')
      end

      it 'displays a preview of the video' do
        page.should have_css('video.sublime', :count => 1)
      end

      it 'saves the provided attributes' do
        @real_estate.reload
        video = @real_estate.media_assets.last
        video.title.should == 'Das neue Video'
        video.is_primary.should be_false
        video.media_type.should == MediaAsset::VIDEO
      end
    end
  end

  describe '#new document' do
    before :each do
      click_on 'Dokument erfassen'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_document_path(@real_estate)
    end

    context 'adding a document' do

      before :each do
        within '.new_media_asset' do
          fill_in 'Titel', :with => 'Das neue Dokument'
          attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"
        end
        click_on 'Dokument speichern'
      end

      it 'renders the edit form' do
        @real_estate.reload
        current_path.should == edit_cms_real_estate_media_asset_path(@real_estate, @real_estate.media_assets.last)
      end

      it 'cannot be checked as primary visual' do
        page.should_not have_css('#media_asset_is_primary[type=checkbox]')
      end

      it 'cannot be checked as floorplan' do
        page.should_not have_css('#media_asset_is_floorplan[type=checkbox]')
      end

      it 'displays a link to the document' do
        page.should have_content('"Das neue Dokument" in neuem Fenster öffnen')
      end

      it 'saves the provided attributes' do
        @real_estate.reload
        video = @real_estate.media_assets.last
        video.title.should == 'Das neue Dokument'
        video.is_primary.should be_false
        video.media_type.should == MediaAsset::DOCUMENT
      end
    end
  end
end
