require 'spec_helper'

describe PointOfInterest do
  describe 'initialize without any attributes' do
    before :each do
      @poi = PointOfInterest.new(:distance => '120 meter')
    end

    it 'does not pass validations' do
      @poi.should_not be_valid
    end

    it 'requires a number for the distance' do
      @poi.should have(1).error_on(:distance)
    end

    it 'has 1 errors' do
      @poi.valid?
      @poi.errors.should have(1).items
    end
  end  
end
