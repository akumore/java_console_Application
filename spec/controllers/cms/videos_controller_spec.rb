# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  before do
    sign_in(Fabricate(:cms_admin))
  end

  describe Cms::VideosController do

    context "On a published real estate" do
      before do
        @video = Fabricate.build(:media_assets_video)
        @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :videos => [@video]
      end

      it "can't create a new video" do
        expect {
          post 'create', :real_estate_id => @real_estate.id, :video => Fabricate.attributes_for(:media_assets_video)
        }.should_not change { @real_estate.reload.videos.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't edit the video" do
        get 'edit', :real_estate_id => @real_estate.id, :id => @video.id
        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't update the video" do
        expect {
          put 'update', :real_estate_id => @real_estate, :id => @video.id, :video => Fabricate.attributes_for(:media_assets_video, :title => 'Updated Video Title')
        }.should_not change { @video.reload.title }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't destroy the video" do
        expect {
          delete 'destroy', :real_estate_id => @real_estate.id, :id => @video.id
        }.should_not change { @real_estate.reload.videos.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end
    end

  end
end
