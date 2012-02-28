require 'spec_helper'

describe Address do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :address => Address.new, :category => Fabricate(:category))
      @address = @real_estate.address
    end

    it 'does not pass validations' do
      @address.should_not be_valid
    end

    it 'requires a street' do
      @address.should have(1).error_on(:street)
    end

    it 'requires a zipcode' do
      @address.should have(1).error_on(:zip)
    end

    it 'requires a city' do
      @address.should have(1).error_on(:city)
    end

    it 'requires a canton' do
      @address.should have(2).error_on(:canton)
    end

    it 'has 5 errors' do
      @address.valid?
      @address.errors.should have(5).items
    end
  end  
end
