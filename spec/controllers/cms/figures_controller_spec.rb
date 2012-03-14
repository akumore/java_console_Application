# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  describe Cms::FiguresController do
    let :real_estate do
      mock_model(RealEstate, :save => true, :update_attributes => true)
    end

    describe '#create' do
      it 'redirects to the new infrastructure tab without an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Figure.stub!(:new).and_return(mock_model(Figure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_infrastructure_path(mock))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit infrastructure tab with an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(mock_model(Infrastructure))
        
        RealEstate.stub!(:find).and_return(mock)        
        Figure.stub!(:new).and_return(mock_model(Figure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_infrastructure_path(mock))
        flash[:success].should_not be_nil
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :figure => Fabricate.build(:figure)
      end

      it 'redirects to the new infrastructure tab without an existing infrastructure' do
        put :update, :real_estate_id => @real_estate.id, :figure=>Fabricate.attributes_for(:figure)
        response.should redirect_to(new_cms_real_estate_infrastructure_path(@real_estate))
        flash[:success].should_not be_nil
      end

      it 'redirects to the edit infrastructure tab with an existing infrastructure' do
        @real_estate.infrastructure = Fabricate.build(:infrastructure)
        put :update, :real_estate_id => @real_estate.id, :figure=>Fabricate.attributes_for(:figure)
        response.should redirect_to(edit_cms_real_estate_infrastructure_path(@real_estate))
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
          put :update, :real_estate_id => @real_estate.id, :figure=>Fabricate.attributes_for(:figure)
          response.should redirect_to [:cms, @real_estate, :figure]
          flash[:alert].should == @access_denied
        end
      end
    end

  end
end