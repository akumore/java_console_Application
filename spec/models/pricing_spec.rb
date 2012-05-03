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
        @pricing.should have(2).error_on(:price_unit)
      end

      it 'requires a "rent" price unit ' do
        @pricing.update_attribute :price_unit, Pricing::PRICE_UNITS_FOR_SALE.first
        @pricing.should have(1).error_on(:price_unit)
      end

      it 'requires a netto rent price' do
        @pricing.should have(2).error_on(:for_rent_netto)
      end

      it 'requires the rent extras' do
        @pricing.should have(2).error_on(:for_rent_extra)
      end

      it 'has 6 errors' do
        @pricing.valid?
        @pricing.errors.should have(6).items
      end
    end

    context 'for sale' do
      before :each do
        @real_estate.offer = RealEstate::OFFER_FOR_SALE
      end

      it 'does require a price_unit' do
        @pricing.should have(2).error_on(:price_unit)
      end

      it 'requires a "sell" price unit ' do
        @pricing.update_attribute :price_unit, Pricing::PRICE_UNITS_FOR_RENT.first
        @pricing.should have(1).error_on(:price_unit)
      end

      it 'requires a sale price' do
        @pricing.should have(2).error_on(:for_sale)
      end

      it 'has 4 errors' do
        @pricing.valid?
        @pricing.errors.should have(4).items
      end
    end
  end
end
