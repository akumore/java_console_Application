# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!


  describe Cms::InformationController do
    describe '#create' do
      let :real_estate do
        mock_model(RealEstate, :save => true, :update_attributes => true)
      end

      it 'redirects to the new pricing tab without an existing pricing' do
        mock = real_estate
        mock.stub!(:pricing).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Information.stub!(:new).and_return(mock_model(Information, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_pricing_path(mock))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit pricing tab with an existing pricing' do
        mock = real_estate
        mock.stub!(:pricing).and_return(mock_model(Pricing))
        Information.stub!(:new).and_return(mock_model(Information, :save => true, :real_estate= => nil))

        RealEstate.stub!(:find).and_return(mock)

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_pricing_path(mock))
        flash[:success].should_not be_nil
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :address => Fabricate.build(:address), :category => Fabricate(:category), :information => Fabricate.build(:information)
      end

      it 'redirects to the new pricing tab without an existing pricing' do
        put :update, :real_estate_id => @real_estate.id, :information=>Fabricate.attributes_for(:information)
        response.should redirect_to(new_cms_real_estate_pricing_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the new pricing tab with an existing pricing' do
        @real_estate.pricing = Fabricate.build(:pricing)

        put :update, :real_estate_id => @real_estate.id
        response.should redirect_to(edit_cms_real_estate_pricing_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :address => Fabricate.build(:address), :information => Fabricate.build(:information)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :information]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          post :update, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :information]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end