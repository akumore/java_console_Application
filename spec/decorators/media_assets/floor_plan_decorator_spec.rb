require 'spec_helper'

module MediaAssets
  describe FloorPlanDecorator do

    let(:floor_plan) do
      Fabricate.build(:media_assets_floor_plan)
    end

    let(:real_estate) do
      Fabricate(:residential_building, :floor_plans => [floor_plan])
    end

    let(:floor_plan_decorator) do
      RealEstateDecorator.decorate(real_estate).floor_plans.first
    end

    it "returns a zoom link with the corresponding id" do
      floor_plan_decorator.zoom_link.should =~ /#floorplan-zoomed-#{floor_plan_decorator.id}/
    end

    context "When additional_description is present" do
      context "and the orientation_degrees is set" do
        it "should render the class tag with the id AND the north arrow tag" do
          real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 180)
          floor_plan_decorator.zoomed_div.should =~ /img.*#{floor_plan.file.url}/
          floor_plan_decorator.zoomed_div.should =~ /floorplan-zoomed-#{floor_plan_decorator.id}/
          floor_plan_decorator.zoomed_div.should =~ /north-arrow-container.*img.*src.*180/
        end
      end

    end

  end
end
