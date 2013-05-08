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
          :additional_costs => 200,
          :inside_parking => 140,
          :outside_parking => 150,
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
      @pricing.additional_costs.should == "CHF 200.00 / Monat"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "CHF 140.00 / Monat"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "CHF 150.00 / Monat"
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
          :additional_costs => 6789,
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

    it 'formats the additional costs' do
      @pricing.additional_costs.should == "CHF 6'789.00"
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

  describe '#render_price_tags' do
    let :pricing do
      PricingDecorator.new(stub(:pricing))
    end

    it 'returns the value element' do
      pricing.render_price_tags('100', 'CHF/J.').should == "<span class=\"value\">100</span>&nbsp;<span class=\"currency\">CHF/J.</span>"
    end
  end

  describe '#price_unit' do
    let :pricing do
      PricingDecorator.new(stub(:pricing, :price_unit => 'yearly'))
    end

    context 'with a sale parking field' do
      it 'returns localized sell price unit' do
        pricing.pricing.stub!(:for_sale?).and_return true
        pricing.price_unit(:double_garage).should == 'CHF'
      end
    end

    context 'with a rent parking field' do
      it 'returns localized sell price unit' do
        pricing.pricing.stub!(:for_sale?).and_return false
        pricing.price_unit(:double_garage).should == 'CHF/Mt.'
      end
    end

    context 'with no pricing field' do
      it 'returns the localized price unit' do
        pricing.price_unit.should == 'CHF/J.'
      end
    end

    context 'with a normal pricing field' do
      it 'returns the localized price unit' do
        pricing.price_unit.should == 'CHF/J.'
      end
    end
  end
end
