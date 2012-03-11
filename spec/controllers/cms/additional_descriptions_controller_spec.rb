# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  let :real_estate do
    Fabricate :real_estate, :category=>Fabricate(:category)
  end

  describe Cms::AdditionalDescriptionsController do
    describe '#create' do
      it 'redirects to the media assets overview tab' do
        post :create, :real_estate_id => real_estate.id, :additional_description=>Fabricate.attributes_for(:additional_description)
        response.should redirect_to(cms_real_estate_media_assets_path(real_estate))
        flash[:success].should_not be_nil
      end
    end

    describe '#create' do
      it 'redirects to the media assets overview tab' do
        put :update, :real_estate_id => real_estate.id, :additional_description=>Fabricate.attributes_for(:additional_description)
        response.should redirect_to(cms_real_estate_media_assets_path(real_estate))
        flash[:success].should_not be_nil
      end
    end
  end
end