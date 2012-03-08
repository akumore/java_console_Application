# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::RealEstatesController do
    describe '#create' do
      it 'redirects to the new address tab' do
        RealEstate.stub!(:new).and_return(real_estate)

        post :create
        response.should redirect_to(new_cms_real_estate_address_path(real_estate))
      end
    end

    describe '#update' do
      it 'redirects to the new address tab without an existing address' do
        mock = real_estate
        mock.stub!(:address).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)

        post :update, :id => mock.id
        response.should redirect_to(new_cms_real_estate_address_path(mock))
      end

      it 'redirects to the edit address tab with an existing address' do
        mock = real_estate
        mock.stub!(:address).and_return(mock_model(Address))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :id => mock.id
        response.should redirect_to(edit_cms_real_estate_address_path(mock))
      end
    end
  end 
end