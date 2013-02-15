require 'spec_helper'

describe Search::SortFields do

  context 'with living utilization' do
    it "should return 'rooms', 'price', 'floor', 'available_from', 'category'" do
      search_fields = Search::SortFields.new(Utilization::LIVING)
      search_fields.fields.should == %w(rooms price available_from category)
    end
  end

  context 'with storing utilization' do
    it "should return 'usable_surface', 'floor', 'available_from'" do
      search_fields = Search::SortFields.new(Utilization::STORING)
      search_fields.fields.should == %w(usable_surface floor available_from)
    end
  end

  context 'with parking utilization' do
    it "should return 'usable_surface', 'floor', 'price', 'available_from'" do
      search_fields = Search::SortFields.new(Utilization::PARKING)
      search_fields.fields.should == []
    end
  end

  context 'with working utilization' do
    it "should return 'usable_surface', 'floor', 'price', 'available_from'" do
      search_fields = Search::SortFields.new(Utilization::WORKING)
      search_fields.fields.should == %w(usable_surface floor price available_from)
    end
  end
end
