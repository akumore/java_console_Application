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


    describe '#authorization as an admin' do
      before do
        @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :address => Fabricate.build(:address), :pricing => Fabricate.build(:pricing)
        @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
      end

      it 'prevents from accessing #edit' do
        get :edit, :id => @real_estate.id
        response.should redirect_to [:cms, @real_estate]
        flash[:alert].should == @access_denied
      end

      it "doesn't prevents admins from accessing #update because of changing state requests" do
        put :update, :id => @real_estate.id
        response.should redirect_to [:cms, @real_estate]
        flash[:alert].should_not == @access_denied
      end
    end


    describe '#authorization as an editor' do
      before do
        controller.current_user.stub!(:role).and_return('editor')
        @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
      end

      it "prevents editors from updating real estate 'published'" do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category)

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end

      it "prevents from updating real estate 'in_review'" do
        real_estate = Fabricate :real_estate, :state => 'in_review', :category => Fabricate(:category)

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end
    end

  end
end