# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  before do
    sign_in(Fabricate(:cms_admin))
  end

  let :category do
    Fabricate :category
  end

  let :real_estate do
    Fabricate :real_estate, :category => category
  end

  describe Cms::AddressesController do
    describe '#create' do
      it 'redirects to the new information tab without an existing information' do
        post :create, :real_estate_id => real_estate.id, :address=>Fabricate.attributes_for(:address)
        response.should redirect_to(new_cms_real_estate_information_path(real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit information tab with an existing information' do
        real_estate.information = Fabricate.build :information
        post :create, :real_estate_id => real_estate.id, :address=>Fabricate.attributes_for(:address)
        response.should redirect_to(edit_cms_real_estate_information_path(real_estate))
        flash[:success].should_not be_nil
      end
    end

    describe '#update' do
      before do
        real_estate.address = Fabricate.build(:address)
      end
      it 'redirects to the new information tab without an existing information' do
        put :update, :real_estate_id => real_estate.id
        response.should redirect_to(new_cms_real_estate_information_path(real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit information tab with an existing information' do
        real_estate.information = Fabricate.build :information

        put :update, :real_estate_id => real_estate.id
        response.should redirect_to(edit_cms_real_estate_information_path(real_estate))
        flash[:success].should_not be_nil
      end
    end


    describe '#authorization' do
      context "Real estate isn't editable" do
        before do
          @real_estate = Fabricate :published_real_estate, :category=>category, :address=>Fabricate.build(:address)
          @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
        end

        it 'prevents from accessing #edit' do
          get :edit, :real_estate_id=>@real_estate.id
          response.should redirect_to [:cms, @real_estate, :address]
          flash[:alert].should == @access_denied
        end

        it 'prevents from accessing #update' do
          post :update, :real_estate_id=>@real_estate.id
          response.should redirect_to [:cms, @real_estate, :address]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end
