# encoding: utf-8
require 'spec_helper'

describe "Cms::MediaAssets" do
  login_cms_editor
  create_category_tree

  before :each do
    @document = Fabricate.build :media_assets_document
    @video = Fabricate.build :media_assets_video
    @image = Fabricate.build :media_assets_image
    @floor_plan = Fabricate.build :media_assets_floor_plan

    @real_estate = Fabricate :real_estate, :category => Fabricate(:category),
                             :images => [@image], :floor_plans => [@floor_plan], :videos => [@video], :documents => [@document]
  end

  it 'takes me to media assets #index' do
    visit edit_cms_real_estate_path(@real_estate)
    click_on 'Bilder & Dokumente'
    current_path.should == cms_real_estate_media_assets_path(@real_estate)
  end

  describe '#index' do
    it 'links to create a new image' do
      visit cms_real_estate_media_assets_path(@real_estate)
      click_on 'Bild erfassen'
      current_path.should == new_cms_real_estate_image_path(@real_estate)
    end

    it 'links to create a new floor plan' do
      visit cms_real_estate_media_assets_path(@real_estate)
      click_on 'Grundriss erfassen'
      current_path.should == new_cms_real_estate_floor_plan_path(@real_estate)
    end

    it 'has a link to create a new video' do
      visit cms_real_estate_media_assets_path(@real_estate)
      click_on 'Video erfassen'
      current_path.should == new_cms_real_estate_video_path(@real_estate)
    end

    it 'has a link to create a new document' do
      visit cms_real_estate_media_assets_path(@real_estate)
      click_on 'Dokument erfassen'
      current_path.should == new_cms_real_estate_document_path(@real_estate)
    end

    context 'images table' do

      it 'shows the list of images' do
        visit cms_real_estate_media_assets_path(@real_estate)
        page.should have_css "#image-#{@image.id}"
      end

      it 'is sortable via drag and drop'

    end

    it 'shows the list of floor plans' do
      visit cms_real_estate_media_assets_path(@real_estate)

      page.should have_css "#floor-plan-#{@floor_plan.id}"
    end

    it 'shows the list of videos' do
      visit cms_real_estate_media_assets_path(@real_estate)
      page.should have_css "#video-#{@video.id}"
    end

    it 'shows the list of documents' do
      visit cms_real_estate_media_assets_path(@real_estate)
      page.should have_css "#document-#{@document.id}"
    end

    context 'On published real estate' do
      before do
        @real_estate.address = Fabricate.build :address
        @real_estate.pricing = Fabricate.build :pricing
        @real_estate.information = Fabricate.build :information
        @real_estate.figure = Fabricate.build :figure
        @real_estate.publish_it!
      end

      it "links to #show of each asset" do
        visit cms_real_estate_media_assets_path(@real_estate)
        page.should have_link "Anzeigen", :href=>cms_real_estate_image_path(@real_estate, @image)
        page.should have_link "Anzeigen", :href=>cms_real_estate_floor_plan_path(@real_estate, @floor_plan)
        page.should have_link "Anzeigen", :href=>cms_real_estate_video_path(@real_estate, @video)
        page.should have_link "Anzeigen", :href=>cms_real_estate_document_path(@real_estate, @document)
      end

      it "doesn't show edit links" do
        visit cms_real_estate_media_assets_path(@real_estate)
        page.should_not have_link 'Bearbeiten'
      end

      it "doesn't show the delete link" do
        visit cms_real_estate_media_assets_path(@real_estate)
        page.should_not have_link 'Löschen'
      end
    end

  end
end
