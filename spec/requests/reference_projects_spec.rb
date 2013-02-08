# encoding: utf-8

require "spec_helper"

describe ReferenceProject do
  monkey_patch_default_url_options

  let :first do
    Fabricate(:gallery_photo,
              :title => 'Titel 1',
              :position => 1
             )
  end

  let :second do
    Fabricate(:gallery_photo,
              :title => 'Titel 2',
              :position => 2
             )
  end

  let :third do
    Fabricate(:gallery_photo,
              :title => 'Titel 3',
              :position => 3
             )
  end

  describe "Gallery Photo Slider" do
    describe 'with existing gallery photos' do
      before do
        @gallery_photos = [first, second, third]
        visit reference_projects_path
      end

      it "shows the gallery photos slider" do
        page.should have_selector('.gallery-photos-slider', :count => 1)
      end

      it "has 3 items in the slider" do
        page.should have_selector('.gallery-photos-slider li', :count => 3)
      end
    end

    describe 'without any gallery photos' do
      before do
        visit reference_projects_path
      end

      it "shows no gallery photos slider" do
        page.should_not have_selector('gallery-photos-slider')
      end
    end
  end
end
