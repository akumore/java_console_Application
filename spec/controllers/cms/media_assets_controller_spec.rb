# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::MediaAssetsController do

    before do
      @asset = Fabricate.build(:media_asset_image)
      @real_estate = Fabricate :published_real_estate, :category=>Fabricate(:category), :media_assets=>[@asset]
    end

    it "can't create assets for a published real estate" do
      post 'create', :real_estate_id=>@real_estate.id, :media_asset=>Fabricate.attributes_for(:media_asset_image)
      response.should redirect_to [:cms, @real_estate, :media_assets]
    end

    it "can't edit asset of published real estate" do
      get 'edit', :real_estate_id=>@real_estate.id, :id=>@asset.id
      response.should redirect_to [:cms, @real_estate, :media_assets]
    end

    it "can't update asset for published real estate" do
      put 'update', :real_estate_id=>@real_estate, :id=>@asset.id
      response.should redirect_to [:cms, @real_estate, :media_assets]
    end

    it "can't destroy assets of published real estate" do
      delete 'destroy', :real_estate_id=>@real_estate.id, :id=>@asset.id
      @real_estate.reload
      @real_estate.media_assets.should_not be_empty
      response.should redirect_to [:cms, @real_estate, :media_assets]
    end

  end
end