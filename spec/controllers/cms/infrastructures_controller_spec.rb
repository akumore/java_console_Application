# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::InfrastructuresController do
    describe '#create' do
      it 'redirects to the new descriptions tab without an existing description' do
        mock = real_estate
        mock.stub!(:descriptions).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Infrastructure.stub!(:new).and_return(mock_model(Infrastructure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_description_path(mock))
      end

      it 'redirects to the edit descriptions tab with an existing description' do
        mock = real_estate
        mock.stub!(:descriptions).and_return(mock_model(Description))
        
        RealEstate.stub!(:find).and_return(mock)        
        Infrastructure.stub!(:new).and_return(mock_model(Infrastructure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_description_path(mock))
      end
    end

    describe '#update' do
      it 'redirects to the new descriptions tab without an existing description' do
        mock = real_estate
        mock.stub!(:descriptions).and_return(nil)
        mock.stub!(:infrastructure).and_return(mock_model(Infrastructure, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_description_path(mock))
      end

      it 'redirects to the new descriptions tab with an existing description' do
        mock = real_estate
        mock.stub!(:descriptions).and_return(mock_model(Description))
        mock.stub!(:infrastructure).and_return(mock_model(Infrastructure, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_description_path(mock))
      end
    end
  end
end