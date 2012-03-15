# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  describe Cms::AdditionalDescriptionsController do
    describe '#create' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
      end

      it 'redirects to the media assets overview tab' do
        post :create, :real_estate_id => @real_estate.id, :additional_description => Fabricate.attributes_for(:additional_description)
        response.should redirect_to(cms_real_estate_media_assets_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :additional_description => Fabricate.build(:additional_description)
      end

      it 'redirects to the media assets overview tab' do
        put :update, :real_estate_id => @real_estate.id, :additional_description => Fabricate.attributes_for(:additional_description)
        response.should redirect_to(cms_real_estate_media_assets_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :additional_description => Fabricate.build(:additional_description)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :additional_description]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          put :update, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :additional_description]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end