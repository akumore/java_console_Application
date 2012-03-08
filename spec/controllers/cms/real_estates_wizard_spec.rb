# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

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

  describe Cms::AddressesController do
    describe '#create' do
      it 'redirects to the new information tab without an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_information_path(mock))
      end

      it 'redirects to the edit information tab with an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(mock_model(Information))

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_information_path(mock))
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
      end

      it 'redirects to the edit information tab with an existing information' do
        mock = real_estate
        mock.stub!(:information).and_return(mock_model(Information))
        mock.stub!(:address).and_return(mock_model(Address, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)
        Address.stub!(:new).and_return(mock_model(Address, :save => true, :real_estate= => nil))

        post :update, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_information_path(mock))
      end
    end
  end

  describe Cms::InformationController do
    describe '#create' do
      it 'redirects to the new pricing tab without an existing pricing' do
        mock = real_estate
        mock.stub!(:pricing).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Information.stub!(:new).and_return(mock_model(Information, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_pricing_path(mock))
      end

      it 'redirects to the edit pricing tab with an existing pricing' do
        mock = real_estate
        mock.stub!(:pricing).and_return(mock_model(Pricing))
        Information.stub!(:new).and_return(mock_model(Information, :save => true, :real_estate= => nil))

        RealEstate.stub!(:find).and_return(mock)

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_pricing_path(mock))
      end
    end

    describe '#update' do
      it 'redirects to the new information tab without an existing information' do
        mock = real_estate
        mock.stub!(:pricing).and_return(nil)
        mock.stub!(:information).and_return(mock_model(Information, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_pricing_path(mock))
      end

      it 'redirects to the new information tab with an existing information' do
        mock = real_estate
        mock.stub!(:pricing).and_return(mock_model(Pricing))
        mock.stub!(:information).and_return(mock_model(Information, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_pricing_path(mock))
      end
    end
  end
end