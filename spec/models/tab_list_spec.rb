require 'spec_helper'

describe TabList do

  let :working_real_estate do
    Fabricate(:commercial_building)
  end

  let :parking_real_estate do
    Fabricate(:commercial_building,
              :utilization => Utilization::PARKING
             )
  end

  describe '#next_step' do
    context "with a working real estate in 'pricing' tab" do
      it "returns 'figure'" do
        tab_list = TabList.new(working_real_estate)
        tab_list.next_step('pricing').should == 'figure'
      end
    end

    context "with a parking real estate in 'pricing' tab" do
      it "returns 'infrastructure'" do
        tab_list = TabList.new(parking_real_estate)
        tab_list.next_step('pricing').should == 'infrastructure'
      end
    end
  end
end
