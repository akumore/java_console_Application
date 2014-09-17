# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  before do
    sign_in(Fabricate(:cms_admin))
  end

  disable_sweep!

  describe Cms::FiguresController do

    describe '#create' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
        @figure_attributes =Fabricate.attributes_for(:figure)
      end

      it 'redirects to the new pricing tab without an existing pricing' do
        post :create, :real_estate_id => @real_estate.id, :figure => @figure_attributes, :force_redirect => true
        response.should redirect_to new_cms_real_estate_pricing_path(@real_estate)
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit pricing tab with an existing pricing' do
        @real_estate.pricing = Fabricate.build :pricing
        post :create, :real_estate_id => @real_estate.id, :figure => @figure_attributes, :force_redirect => true
        response.should redirect_to(edit_cms_real_estate_pricing_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'render edit again if offer html changed' do
        post :create, :real_estate_id => @real_estate.id, :figure => @figure_attributes.merge(:covered_slot => 3)
        expect(assigns(:offer_html_changed)).to be_true
        response.should render_template('edit')

        post :update, :real_estate_id => @real_estate.id, :figure => @figure_attributes.merge(:covered_slot => 3)
        response.should redirect_to new_cms_real_estate_pricing_path(@real_estate)
        flash[:success].should_not be_nil
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :figure => Fabricate.build(:figure)
        @figure_attributes =Fabricate.attributes_for(:figure)
      end

      it 'redirects to the new pricing tab without an existing pricing' do
        put :update, :real_estate_id => @real_estate.id, :figure => @figure_attributes
        response.should redirect_to(new_cms_real_estate_pricing_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit pricing tab with an existing pricing' do
        @real_estate.pricing = Fabricate.build(:pricing)
        put :update, :real_estate_id => @real_estate.id, :figure => @figure_attributes
        response.should redirect_to(edit_cms_real_estate_pricing_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'render edit again if offer html changed' do
        post :update, :real_estate_id => @real_estate.id, :figure => @figure_attributes.merge(:covered_slot => 3)
        expect(assigns(:offer_html_changed)).to be_true
        response.should render_template('edit')

        post :update, :real_estate_id => @real_estate.id, :figure => @figure_attributes.merge(:covered_slot => 3)
        response.should redirect_to new_cms_real_estate_pricing_path(@real_estate)
        flash[:success].should_not be_nil
      end
    end

    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :figure => Fabricate.build(:figure)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :figure]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          put :update, :real_estate_id => @real_estate.id, :figure => Fabricate.attributes_for(:figure)
          response.should redirect_to [:cms, @real_estate, :figure]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end
