# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user
  disable_sweep!

  let :real_estate do
    mock_model(RealEstate, :save => true, :update_attributes => true)
  end

  describe Cms::FiguresController do
    describe '#create' do
      it 'redirects to the new infrastructure tab without an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(nil)

        RealEstate.stub!(:find).and_return(mock)
        Figure.stub!(:new).and_return(mock_model(Figure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_infrastructure_path(mock))
        flash.now[:success].should_not be_nil
      end

      it 'redirects to the edit infrastructure tab with an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(mock_model(Infrastructure))
        
        RealEstate.stub!(:find).and_return(mock)        
        Figure.stub!(:new).and_return(mock_model(Figure, :save => true, :real_estate= => nil))

        post :create, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_infrastructure_path(mock))
        flash.now[:success].should_not be_nil
      end
    end

    describe '#update' do
      it 'redirects to the new infrastructure tab without an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(nil)
        mock.stub!(:figure).and_return(mock_model(Figure, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(new_cms_real_estate_infrastructure_path(mock))
        flash.now[:success].should_not be_nil
      end

      it 'redirects to the new infrastructure tab with an existing infrastructure' do
        mock = real_estate
        mock.stub!(:infrastructure).and_return(mock_model(Infrastructure))
        mock.stub!(:figure).and_return(mock_model(Figure, :update_attributes => true))

        RealEstate.stub!(:find).and_return(mock)

        post :update, :real_estate_id => mock.id
        response.should redirect_to(edit_cms_real_estate_infrastructure_path(mock))
        flash.now[:success].should_not be_nil
      end
    end
  end
end