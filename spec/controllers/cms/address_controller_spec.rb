# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::AddressesController do
    describe '#create' do
      it 'redirects to the new information tab without an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_information_path(mock))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit information tab with an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(mock_model(Information))

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_information_path(mock))
        flash[:success].should_not be_nil
      end
    end

    describe '#update' do
      it 'redirects to the new information tab without an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(nil)
        mock.stub!(:address).and_return(mock_model(Address, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_information_path(mock))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit information tab with an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(mock_model(Information))
        mock.stub!(:address).and_return(mock_model(Address, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :update, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_information_path(mock))
        flash[:success].should_not be_nil
      end
    end
  end
end