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
          floor_plan_decorator.zoomed_div.should =~ /north-arrow-overlay/
          floor_plan_decorator.zoomed_div.should =~ /north-arrow-180/
        end
      end

      context "and the orientation_degrees is NOT set" do
        it "does not return the north arrow overlay" do
          floor_plan_decorator.north_arrow_overlay.should == nil
        end
      end
    end

    context "When additional_description is absent" do
      it "returns a div with ONLY the fully zoomed image as img tag" do
        floor_plan_decorator.zoomed_div.should =~ /img.*#{floor_plan.file.url}/
        floor_plan_decorator.zoomed_div.should =~ /floorplan-zoomed-#{floor_plan_decorator.id}/
        floor_plan_decorator.zoomed_div.should_not =~ /north-arrow-overlay/
      end

      it "does not return the north arrow overlay" do
        floor_plan_decorator.north_arrow_overlay.should == nil
      end
    end

    context "When orientation_degrees is present" do
      context "and correct" do
        it "should render round orientation" do
          real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 183)
          floor_plan_decorator.north_arrow_overlay.should =~ /north-arrow-180/
        end

        it "should render round orientation" do
          real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 191.9)
          floor_plan_decorator.north_arrow_overlay.should =~ /north-arrow-190/
        end
      end

      context "and incorrect" do
        it "should render orientation 0 degrees" do
          real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 'foobar')
          floor_plan_decorator.north_arrow_overlay.should =~ /north-arrow-0/
        end
      end
    end

    context "When orientation_degrees is blank" do
      it "does not return the north arrow overlay" do
        floor_plan_decorator.north_arrow_overlay.should == nil
      end
    end

  end
end
