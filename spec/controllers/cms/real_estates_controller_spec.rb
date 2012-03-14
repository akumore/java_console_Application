# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::RealEstatesController do
    let :category do
      Fabricate :category
    end


    describe '#create' do
      it 'redirects to the new address tab' do
        post :create, :real_estate => Fabricate.attributes_for(:real_estate, :category_id => category.id)
        response.should redirect_to new_cms_real_estate_address_path(RealEstate.first)
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => category
      end

      it 'redirects to the new address tab without an existing address' do
        put :update, :id => @real_estate.id
        response.should redirect_to new_cms_real_estate_address_path(@real_estate)
      end

      it 'redirects to the edit address tab with an existing address' do
        @real_estate.address = Fabricate.build(:address)

        put :update, :id => @real_estate.id
        response.should redirect_to edit_cms_real_estate_address_path(@real_estate)
      end
    end

  end
end