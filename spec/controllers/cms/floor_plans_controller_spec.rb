# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::FloorPlansController do

    context "On a published real estate" do
      before do
        @floor_plan = Fabricate.build(:media_assets_floor_plan)
        @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :floor_plans => [@floor_plan]
      end

      it "can't create a floor plan" do
        expect {
          post 'create', :real_estate_id => @real_estate.id, :floor_plan => Fabricate.attributes_for(:media_assets_floor_plan)
        }.should_not change { @real_estate.reload.floor_plans.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't edit the floor plan" do
        get 'edit', :real_estate_id => @real_estate.id, :id => @floor_plan.id
        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't update the floor plan" do
        expect {
          put 'update', :real_estate_id => @real_estate, :id => @floor_plan.id, :floor_plan => Fabricate.attributes_for(:media_assets_floor_plan, :title => 'Updated Image Title')
        }.should_not change { @floor_plan.reload.title }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't destroy the floor plan" do
        expect {
          delete 'destroy', :real_estate_id => @real_estate.id, :id => @floor_plan.id
        }.should_not change { @real_estate.reload.floor_plans.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

    end
  end
end