# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::ImagesController do

    context "On a published real estate" do
      before do
        @image = Fabricate.build(:media_assets_image)
        @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :images => [@image]
      end

      it "can't create a new image" do
        expect {
          post 'create', :real_estate_id => @real_estate.id, :image => Fabricate.attributes_for(:media_assets_image)
        }.should_not change { @real_estate.reload.images.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't edit the image" do
        get 'edit', :real_estate_id => @real_estate.id, :id => @image.id
        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't update the image" do
        expect {
          put 'update', :real_estate_id => @real_estate, :id => @image.id, :image => Fabricate.attributes_for(:media_assets_image, :title => 'Updated Image Title')
        }.should_not change { @image.reload.title }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't destroy the image" do
        expect {
          delete 'destroy', :real_estate_id => @real_estate.id, :id => @image.id
        }.should_not change { @real_estate.reload.images.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end
    end

  end
end