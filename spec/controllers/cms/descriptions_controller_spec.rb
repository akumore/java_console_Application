# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::DescriptionsController do
    describe '#create' do
      it 'redirects to the media assets overview tab' do
        mock = real_estate

        RealEstate.stub!(:find).and_return(mock)
        Description.stub!(:new).and_return(mock_model(Description, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(cms_real_estate_media_assets_path(mock))
        flash.now[:success].should_not be_nil
      end
    end

    describe '#create' do
      it 'redirects to the media assets overview tab' do
        mock = real_estate
        mock.stub!(:descriptions).and_return(mock_model(Description, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(cms_real_estate_media_assets_path(mock))
        flash.now[:success].should_not be_nil
      end
    end
  end
end