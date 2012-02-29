require 'spec_helper'

describe Pricing do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = Fabricate.build(:real_estate, :pricing => Pricing.new, :category => Fabricate(:category))
      @pricing = @real_estate.pricing
    end

    it 'does not pass validations' do
      @pricing.should_not be_valid
    end

    context 'for rent' do
      before :each do
        @real_estate.offer = RealEstate::OFFER_FOR_RENT
      end

      it 'requires a price unit' do
        @pricing.should have(1).error_on(:price_unit)
      end

      it 'requires a netto rent price' do
        @pricing.should have(1).error_on(:for_rent_netto)
      end

      it 'requires the rent extras' do
        @pricing.should have(1).error_on(:for_rent_extra)
      end

      it 'has 3 errors' do
        @pricing.valid?
        @pricing.errors.should have(3).items
      end
    end

    context 'for sale' do
      before :each do
        @real_estate.offer = RealEstate::OFFER_FOR_SALE
      end

      it 'does not require a price_unit' do
        @pricing.should have(0).error_on(:price_unit)
      end

      it 'requires a sale price' do
        @pricing.should have(1).error_on(:for_sale)
      end

      it 'has 1 errors' do
        @pricing.valid?
        @pricing.errors.should have(1).items
      end
    end
  end  
end
