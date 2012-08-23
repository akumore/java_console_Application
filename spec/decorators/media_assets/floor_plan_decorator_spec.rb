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
      floor_plan_decorator.should_receive(:real_estate_floorplan_path).with(floor_plan.real_estate, floor_plan).and_return('link_to_floor_plan')
      floor_plan_decorator.zoom_link.should =~ /link_to_floor_plan/
    end

  end
end
