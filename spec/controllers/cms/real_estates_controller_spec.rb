# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::RealEstatesController do
    let :category do
      Fabricate :category
    end

    let :editor do
      Fabricate :cms_editor
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
        @real_estate = Fabricate :published_real_estate,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :pricing => Fabricate.build(:pricing),
          :information => Fabricate.build(:information),
          :figure => Fabricate.build(:figure)
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

      it "doesn't allow to destroy real_estate in state 'published'" do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category)

        delete :destroy, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied

      end

      %w(editing in_review).each do |state|
        it "allows to destroy real estate in state '#{state}'" do
          real_estate = Fabricate :real_estate, :state => state, :category => Fabricate(:category), :editor => editor

          delete :destroy, :id => real_estate.id
          response.should redirect_to cms_real_estates_url
          flash[:notice].should == I18n.t('cms.real_estates.index.destroyed', :title => real_estate.title)
        end
      end
    end


    describe '#authorization as an editor' do
      before do
        controller.current_user.stub!(:role).and_return('editor')
        @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
      end

      it 'prevents from accessing #edit' do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category)

        get :edit, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end

      it "doesn't prevent editors from accessing #update because of changing state requests" do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :address => Fabricate.build(:address),
                                :pricing => Fabricate.build(:pricing), :information => Fabricate.build(:information),
                                :figure => Fabricate.build(:figure)

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should_not == @access_denied
      end

      it "prevents from updating real estate 'in_review'" do
        real_estate = Fabricate :real_estate, :state => 'in_review', :category => Fabricate(:category), :editor => editor

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end

      it "allows to destroy real_estate in 'editing'" do
        real_estate = Fabricate :real_estate, :state => 'editing', :category => Fabricate(:category)

        delete :destroy, :id=>real_estate.id
        response.should redirect_to cms_real_estates_url
        flash[:notice].should == I18n.t('cms.real_estates.index.destroyed', :title => real_estate.title)
      end

      %w(in_review published).each do |state|
        it "doesn't allow to destroy real estate in state '#{state}'" do
          real_estate = Fabricate :real_estate, :state => state, :category => Fabricate(:category), :editor => Fabricate(:cms_editor)

          delete :destroy, :id => real_estate.id
          response.should redirect_to [:cms, real_estate]
          flash[:alert].should == @access_denied
        end
      end

    end

  end
end
