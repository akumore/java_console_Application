require 'spec_helper'

describe PricingDecorator do
  before { ApplicationController.new.set_current_view_context }

  context 'for rent' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :offer => RealEstate::OFFER_FOR_RENT,
        :pricing => Fabricate.build(:pricing,
          :price_unit => 'monthly',
          :for_rent_netto => 2000,
          :for_rent_extra => 200,
          :inside_parking => 140,
          :outside_parking => 150,
          :inside_parking_temporary => 160,
          :outside_parking_temporary => 170,
          :for_rent_depot => 2000,
          :estimate => ''
        )
      )

      @pricing = PricingDecorator.new(@real_estate.pricing)
    end

    it 'formats the list price' do
      @pricing.list_price.should == "CHF 2'000.00"
    end

    it 'formats the price' do
      @pricing.price.should == @pricing.for_rent_netto
    end

    it 'formats the netto rent price' do
      @pricing.for_rent_netto.should == "CHF 2'000.00 / Monat"
    end

    it 'formats the rent extra price' do
      @pricing.for_rent_extra.should == "CHF 200.00 / Monat"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "CHF 140.00 / Monat"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "CHF 150.00 / Monat"
    end

    it 'formats the temporary inside parking price' do
      @pricing.inside_parking_temporary.should == "CHF 160.00 / Monat"
    end

    it 'formats the temporary outside parking price' do
      @pricing.outside_parking_temporary.should == "CHF 170.00 / Monat"
    end

    it 'formats the rent depot' do
      @pricing.for_rent_depot.should == "CHF 2'000.00"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 200 - 3000'
        @pricing.reload
      end

      it 'formats the estimate price' do
        @pricing.estimate.should == 'CHF 200 - 3000 / Monat'
      end

      it 'overrides the for rent price' do
        @pricing.for_rent_netto.should == @pricing.estimate
      end
    end
  end

  context 'for sale' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :offer => RealEstate::OFFER_FOR_SALE,
        :pricing => Fabricate.build(:pricing,
          :for_sale => 123456,
          :price_unit => 'sell',
          :inside_parking => 140,
          :outside_parking => 150,
          :inside_parking_temporary => 160,
          :outside_parking_temporary => 170,
          :estimate => ''
        )
      )

      @pricing = PricingDecorator.new(@real_estate.pricing)
    end

    it 'formats the list price' do
      @pricing.list_price.should == "CHF 123'456.00"
    end

    it 'formats the price' do
      @pricing.price.should == @pricing.for_sale
    end

    it 'formats the sale price' do
      @pricing.for_sale.should == "CHF 123'456.00 / Verkaufspreis"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "CHF 140.00 / Verkaufspreis"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "CHF 150.00 / Verkaufspreis"
    end

    it 'formats the temporary inside parking price' do
      @pricing.inside_parking_temporary.should == "CHF 160.00 / Verkaufspreis"
    end

    it 'formats the temporary outside parking price' do
      @pricing.outside_parking_temporary.should == "CHF 170.00 / Verkaufspreis"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 15000 - 13000'
        @pricing.reload
      end

      it 'formats the estimate price' do
        @pricing.estimate.should == 'CHF 15000 - 13000 / Verkaufspreis'
      end

      it 'overrides the for rent price' do
        @pricing.for_rent_netto.should == @pricing.estimate
      end
    end
  end
end
