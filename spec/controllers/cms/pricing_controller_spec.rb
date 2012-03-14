# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::PricingsController do
    describe '#create' do
      it 'redirects to the new figures tab without an existing figure' do
        mock = real_estate
        mock.stub!(:figure).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Pricing.stub!(:new).and_return(mock_model(Pricing, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_figure_path(mock))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit figures tab with an existing figures' do
        mock = real_estate
        mock.stub!(:figure).and_return(mock_model(Figure))

        RealEstate.stub!(:find).and_return(mock)
        Pricing.stub!(:new).and_return(mock_model(Pricing, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_figure_path(mock))
        flash[:success].should_not be_nil
      end
    end

    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :pricing => Fabricate.build(:pricing)
      end

      it 'redirects to the new figures tab without an existing figure' do
        put :update, :real_estate_id => @real_estate.id, :pricing=>Fabricate.attributes_for(:pricing)
        response.should redirect_to(new_cms_real_estate_figure_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the new figures tab with an existing figure' do
        @real_estate.figure = Fabricate.build(:figure)
        put :update, :real_estate_id => @real_estate.id, :pricing=>Fabricate.attributes_for(:pricing)
        response.should redirect_to(edit_cms_real_estate_figure_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :pricing => Fabricate.build(:pricing)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :pricing]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          put :update, :real_estate_id => @real_estate.id, :pricing=>Fabricate.attributes_for(:pricing)
          response.should redirect_to [:cms, @real_estate, :pricing]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end