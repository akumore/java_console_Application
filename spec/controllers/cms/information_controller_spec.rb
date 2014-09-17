# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  before { ApplicationController.new.set_current_view_context }

  before do
    sign_in(Fabricate(:cms_admin))
  end
  disable_sweep!

  describe Cms::InformationController do
    describe '#create' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
        @information_attributes = Fabricate.attributes_for(:information)
      end

      it 'render edit when html fields are updated automatically' do
        post :create, :real_estate_id => @real_estate.id, :information => @information_attributes
        expect(assigns(:infrastructure_html_changed)).to be_true
        response.should render_template('edit')

        # when click on save again goto media assets
        post :update, :real_estate_id => @real_estate.id, :information => @information_attributes
        response.should redirect_to cms_real_estate_media_assets_path(@real_estate)
        flash[:success].should_not be_nil
      end

      it 'redirects to the media assets overview tab' do
        post :create, :real_estate_id => @real_estate.id, :information => {}
        response.should redirect_to cms_real_estate_media_assets_path(@real_estate)
        flash[:success].should_not be_nil
      end

      it 'redirects to the new media_assets tab without an existing media_assets' do
        post :create, :real_estate_id => @real_estate.id, :information => @information_attributes.merge(:has_cable_tv => true)
        response.should_not redirect_to cms_real_estate_media_assets_path(@real_estate)
        response.should render_template('edit')
        assigns(:original_interior_html).should_not be_nil
      end

    end

    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :address => Fabricate.build(:address), :category => Fabricate(:category), :information => Fabricate.build(:information)
      end

      it 'redirects to the media assets overview tab' do
        put :update, :real_estate_id => @real_estate.id, :information => Fabricate.attributes_for(:information)
        response.should redirect_to(cms_real_estate_media_assets_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end

    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :information => Fabricate.build(:information)
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
