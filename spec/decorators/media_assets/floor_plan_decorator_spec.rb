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

    describe 'north arrow overlay' do

      let(:real_estate) do
        RealEstateDecorator.decorate Fabricate(:residential_building)
      end

      context "When orientation_degrees is present" do
        context "and correct" do
          it "should render round orientation" do
            real_estate.floor_plans << Fabricate.build(:media_assets_floor_plan, :orientation_degrees => 183)
            real_estate.floor_plans.first.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*180/
          end

          it "should render round orientation" do
            real_estate.floor_plans << Fabricate.build(:media_assets_floor_plan, :orientation_degrees => 191.9)
            real_estate.floor_plans.first.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*190/
          end
        end

        context "and incorrect" do
          it "should render orientation 0 degrees" do
            real_estate.floor_plans << Fabricate.build(:media_assets_floor_plan, :orientation_degrees => 'foobar')
            real_estate.floor_plans.first.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*0/
          end
        end
      end

      context "and orientation_degrees is blank" do
        it "does not return the north arrow overlay" do
          real_estate.floor_plans << Fabricate.build(:media_assets_floor_plan, :orientation_degrees => '')
          real_estate.floor_plans.first.north_arrow_overlay.should == nil
        end
      end
    end
  end
end
