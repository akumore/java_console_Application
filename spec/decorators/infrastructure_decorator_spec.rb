# encoding: utf-8
require 'spec_helper'

describe InfrastructureDecorator do
  before { ApplicationController.new.set_current_view_context }

  before :each do
    @real_estate = Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :utilization => Utilization::LIVING,
      :infrastructure => Fabricate.build(:infrastructure)
    )

    @real_estate.infrastructure.points_of_interest << PointOfInterest.new(:name => 'shopping', :distance => 200)
    @real_estate.infrastructure.points_of_interest << PointOfInterest.new(:name => 'public_transport', :distance => 100)
    @infrastructure = InfrastructureDecorator.new(@real_estate.infrastructure)
  end

  describe '#distances' do
    it 'formats points of interest' do
      @infrastructure.distances.should == ['Einkaufen 200 m', 'Öffentlicher Verkehr 100 m']
    end
  end
end
