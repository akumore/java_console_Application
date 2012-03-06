require "spec_helper"

describe Cms::SecuredHelper do
  include Devise::TestHelpers


  describe "fireable events" do
    before do
      @cms_user = Fabricate(:cms_user)
      @controller.stub!(:current_user).and_return(@cms_user)

      @real_estate = Fabricate(:real_estate, :category => Fabricate(:category), :address => Fabricate.build(:address),
                               :pricing => Fabricate.build(:pricing), :figure => Fabricate.build(:figure),
                               :information => Fabricate.build(:information), :infrastructure => Fabricate.build(:infrastructure))
      @all_events = RealEstate.state_machine.events
    end


    context "As an editor" do
      before do
        @cms_user.stub!(:role).and_return(:editor)
      end

      it "returns event for proceeding to 'in_review' state" do
        helper.fireable_events(@real_estate).should == @all_events.select { |e| e.name == :review_it }
      end

      it "returns event for unpublishing published real estate" do
        @real_estate.stub!(:state).and_return('published')
        helper.fireable_events(@real_estate).should == @all_events.select { |e| e.name == :unpublish_it }
      end

      it "returns no event if real estate not ready for reviewing" do
        @real_estate.stub!(:valid_for_publishing?).and_return(false)
        helper.fireable_events(@real_estate).should == []
      end
    end

    context "As an admin" do
      before do
        @cms_user.stub!(:role).and_return(:admin)
      end

      it "returns event for proceeding to 'published' state directly" do
        helper.fireable_events(@real_estate).should == @all_events.select { |e| e.name == :publish_it }
      end

      it "returns event for unpublishing published real estate" do
        @real_estate.stub!(:state).and_return('published')
        helper.fireable_events(@real_estate).should == @all_events.select { |e| e.name == :unpublish_it }
      end

      it "returns events for rejecting or publishing real estate 'in_review'" do
        @real_estate.stub!(:state).and_return('in_review')
        helper.fireable_events(@real_estate).should == @all_events.select { |e| [:reject_it, :publish_it].include? e.name }
      end

      it "returns events for rejecting invalid real estate 'in_review'" do
        @real_estate.stub!(:state).and_return('in_review')
        @real_estate.stub!(:valid_for_publishing?).and_return(false)
        helper.fireable_events(@real_estate).should == @all_events.select { |e| e.name == :reject_it }
      end
    end

  end

end