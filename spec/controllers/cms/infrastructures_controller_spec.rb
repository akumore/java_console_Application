# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  describe Cms::InfrastructuresController do

    let :infrastructure_attributes do
      Fabricate.attributes_for(:infrastructure)
    end

    describe '#create' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
      end

      it 'redirects to the new descriptions tab without an existing description' do
        post :create, :real_estate_id => @real_estate.id, :infrastructure => infrastructure_attributes
        response.should redirect_to new_cms_real_estate_additional_description_path(@real_estate)
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit descriptions tab with an existing description' do
        @real_estate.additional_description = Fabricate.build :additional_description

        post :create, :real_estate_id => @real_estate.id, :infrastructure => infrastructure_attributes
        response.should redirect_to edit_cms_real_estate_additional_description_path(@real_estate)
        flash[:success].should_not be_nil
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :infrastructure => Fabricate.build(:infrastructure)
      end

      it 'redirects to the new descriptions tab without an existing description' do
        put :update, :real_estate_id => @real_estate.id, :infrastructure => infrastructure_attributes
        response.should redirect_to(new_cms_real_estate_additional_description_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the descriptions tab with an existing description' do
        @real_estate.additional_description = Fabricate.build(:additional_description)

        put :update, :real_estate_id => @real_estate.id, :infrastructure => infrastructure_attributes
        response.should redirect_to(edit_cms_real_estate_additional_description_path(@real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :infrastructure => Fabricate.build(:infrastructure)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id => @real_estate.id
          response.should redirect_to [:cms, @real_estate, :infrastructure]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          put :update, :real_estate_id => @real_estate.id, :infrastructure => infrastructure_attributes
          response.should redirect_to [:cms, @real_estate, :infrastructure]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end