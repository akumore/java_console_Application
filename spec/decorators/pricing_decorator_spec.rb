require 'spec_helper'

describe PricingDecorator do
  before { ApplicationController.new.set_current_view_context }

  context 'for rent' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :offer => Offer::RENT,
        :pricing => Fabricate.build(:pricing,
          :price_unit => 'monthly',
          :for_rent_netto => 2000,
          :for_rent_extra => 200,
          :inside_parking => 140,
          :outside_parking => 150,
          :for_rent_depot => 2000,
          :estimate => ''
        )
      )

      @pricing = PricingDecorator.new(@real_estate.pricing)
    end

    it 'formats the list price' do
      @pricing.list_price.should == "CHF 2'200.00"
    end

    it 'formats the price' do
      @pricing.price.should == @pricing.for_rent_brutto
    end

    it 'formats the netto rent price' do
      @pricing.for_rent_netto.should == "CHF 2'000.00 / Monat"
    end

    it 'formats the brutto rent price' do
      @pricing.for_rent_brutto.should == "CHF 2'200.00 / Monat"
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

    it 'formats the rent depot' do
      @pricing.for_rent_depot.should == "CHF 2'000.00"
    end

    it 'formats all parking prices monthly' do
      @pricing.update_attribute :price_unit, 'year_m2'
      @pricing.inside_parking.should == "CHF 140.00 / Monat"
      @pricing.outside_parking.should == "CHF 150.00 / Monat"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 200 - 3000'
        @pricing.reload
      end

      it 'formats the estimate price' do
        @pricing.estimate.should == 'CHF 200 - 3000'
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
        :offer => Offer::SALE,
        :pricing => Fabricate.build(:pricing,
          :for_sale => 123456,
          :price_unit => 'sell',
          :inside_parking => 140,
          :outside_parking => 150,
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
      @pricing.for_sale.should == "CHF 123'456.00"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "CHF 140.00"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "CHF 150.00"
    end

    it 'formats all parking prices monthly' do
      @pricing.update_attribute :price_unit, 'sell_m2'
      @pricing.inside_parking.should == "CHF 140.00"
      @pricing.outside_parking.should == "CHF 150.00"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 15000 - 13000'
        @pricing.reload
      end

      it 'formats the estimate price' do
        @pricing.estimate.should == 'CHF 15000 - 13000'
      end

      it 'overrides the for sale price' do
        @pricing.for_sale.should == @pricing.estimate
      end
    end
  end
end
