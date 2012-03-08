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


    describe '#authentication' do
      context "Real estate isn't editable" do
        before do
          real_estate.stub!(:state).and_return('published')
          RealEstate.stub!(:find).and_return(real_estate)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id=>real_estate.id
          response.should redirect_to [:cms, real_estate, :address]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          post :update, :real_estate_id=>real_estate.id
          response.should redirect_to [:cms, real_estate, :address]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end