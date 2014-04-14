require 'spec_helper'

describe PricingDecorator do
  before { ApplicationController.new.set_current_view_context }

  context 'for rent' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :offer => Offer::RENT,
        :pricing => Fabricate.build(:pricing,
          :display_estimated_available_from => 'Mai 2012',
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

    context 'with an estimate avilability date' do
      it 'has the formatted availability date' do
        @pricing.available_from_compact.should == 'ab Mai 2012'
      end

      it 'has the pure availability date' do
        @pricing.available_from.should == 'Mai 2012'
      end
    end

    context 'without an estimate availability date' do
      before :each do
        @real_estate.pricing.stub!(:display_estimated_available_from).and_return(nil)
      end

      it 'has the formatted availability date' do
        @real_estate.pricing.stub!(:available_from).and_return(Date.parse('20.05.2030'))
        @pricing.available_from_compact.should == 'ab 20.05.2030'
      end

      it 'has the pure availability date' do
        @real_estate.pricing.stub!(:available_from).and_return(Date.parse('20.05.2030'))
        @pricing.available_from.should == '20.05.2030'
      end

      it 'shows past availability dates as immediately available' do
        @real_estate.pricing.stub!(:available_from).and_return(Date.parse('20.05.1986'))
        @pricing.available_from.should == 'sofort'
      end
    end

    it 'formats the list price' do
      @pricing.list_price.should == "2 200.00 CHF/Mt."
    end

    it 'formats the netto rent price' do
      @pricing.for_rent_netto.should == "2 000.00"
    end

    it 'formats the brutto rent price' do
      @pricing.for_rent_brutto.should == "2 200.00"
    end

    it 'formats the rent extra price' do
      @pricing.additional_costs.should == "200.00"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "140.00"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "150.00"
    end

    it 'formats all parking prices monthly' do
      @pricing.update_attribute :price_unit, 'year_m2'
      @pricing.inside_parking.should == "140.00"
      @pricing.outside_parking.should == "150.00"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 200 - 3000'
        @pricing.reload
      end

      it 'returns the estimate price' do
        @pricing.estimate.should == 'CHF 200 - 3000'
      end

      it 'retruns the estimate price as list price' do
        @pricing.list_price.should == 'CHF 200 - 3000'
      end

      it 'does not override the for rent price' do
        @pricing.for_rent_netto.should == @pricing.for_rent_netto
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
      @pricing.list_price.should == "123 456.00 CHF"
    end

    it 'formats the sale price' do
      @pricing.for_sale.should == "123 456.00"
    end

    it 'formats the additional costs' do
      @pricing.additional_costs.should == "6 789.00"
    end

    it 'formats the inside parking price' do
      @pricing.inside_parking.should == "140.00"
    end

    it 'formats the outside parking price' do
      @pricing.outside_parking.should == "150.00"
    end

    it 'formats all parking prices monthly' do
      @pricing.update_attribute :price_unit, 'sell_m2'
      @pricing.inside_parking.should == "140.00"
      @pricing.outside_parking.should == "150.00"
    end

    context 'when an estimated price is set' do
      before :each do
        @pricing.update_attribute :estimate, 'CHF 15000 - 13000'
        @pricing.reload
      end

      it 'formats the estimate price' do
        @pricing.estimate.should == 'CHF 15000 - 13000'
      end

      it 'does not override the for sale price' do
        @pricing.for_sale.should == @pricing.for_sale
      end
    end
  end

  describe '#render_price_tags' do
    let :pricing do
      PricingDecorator.new(stub(:pricing, :supports_monthly_prices? => true))
    end

    it 'returns the value element' do
      expect(pricing.render_price_tags('100', 'yearly', :test_string)).to eq("<span class=\"col col1 test_string\">100 CHF/J.</span>")
    end
  end

  describe '#price_unit' do
    let :pricing do
      PricingDecorator.new(stub(:pricing, :price_unit => 'yearly', :estimate => ''))
    end

    context 'with a sale parking field' do
      it 'returns localized sell price unit' do
        pricing.pricing.stub!(:for_sale?).and_return true
        expect(pricing.price_unit(:double_garage)).to eq('sell')
      end
    end

    context 'with a rent parking field' do
      it 'returns localized sell price unit' do
        pricing.pricing.stub!(:for_sale?).and_return false
        expect(pricing.price_unit(:double_garage)).to eq('monthly')
      end
    end

    context 'with no pricing field' do
      it 'returns the localized price unit' do
        expect(pricing.price_unit).to eq('yearly')
      end
    end

    context 'with a normal pricing field' do
      it 'returns the localized price unit' do
        expect(pricing.price_unit(:for_rent_netto)).to eq('yearly')
      end
    end

    context 'with a monthly pricing field' do
      it 'returns the localized price unit' do
        expect(pricing.price_unit(:for_rent_netto_monthly)).to eq('monthly')
      end
    end
  end

  describe '#formatted_price' do
    let :price do
      PricingDecorator.new Pricing.new
    end

    it 'returns the correct price' do
      price.formatted_price('one hundred millions').should == 'one hundred millions'
      price.formatted_price(1).should == '1.00'
      price.formatted_price(999999).should == '999 999.00'
      price.formatted_price(1000000).should == '1 Mio.'
      price.formatted_price(1000000000).should == '1 Milliarde'
      price.formatted_price(0).should == '0.00'
    end
  end

  describe '#formatted_price_with_currency' do
    let :price do
      PricingDecorator.new Pricing.new
    end

    it 'returns the correct price' do
      price.formatted_price_with_currency(1).should == '1.00 CHF'
      price.formatted_price_with_currency(999999).should == '999 999.00 CHF'
      price.formatted_price_with_currency(1000000).should == '1 Mio. CHF'
      price.formatted_price_with_currency(1000000000).should == '1 Milliarde CHF'
      price.formatted_price_with_currency(0).should == '0.00 CHF'
    end
  end

  describe '#formatted_price_with_price_unit' do
    let :price do
      PricingDecorator.new(stub(:pricing, :price_unit => 'monthly', :estimate => ''))
    end

    it 'returns the correct price' do
      price.formatted_price_with_price_unit('one hundred millions').should == 'one hundred millions CHF/Mt.'
      price.formatted_price_with_price_unit(1).should == '1.00 CHF/Mt.'
      price.formatted_price_with_price_unit(999999).should == '999 999.00 CHF/Mt.'
      price.formatted_price_with_price_unit(1000000).should == '1 Mio. CHF/Mt.'
      price.formatted_price_with_price_unit(1000000000).should == '1 Milliarde CHF/Mt.'
      price.formatted_price_with_price_unit(0).should == '0.00 CHF/Mt.'
    end
  end

  describe '#more_than_seven_digits?' do
    let :price do
      PricingDecorator.new Pricing.new
    end

    context 'when number has more than seven digits' do
      it 'returns true' do
        price.more_than_seven_digits?(1000000).should be_true
      end
    end

    context 'when number has less than seven digits' do
      it 'returns false' do
        price.more_than_seven_digits?(999999).should be_false
      end
    end

    context 'when number is a string (estimate)' do
      it 'returns false' do
        price.more_than_seven_digits?('300 mio').should be_false
      end
    end
  end

  describe '#price_to_be_displayed' do
    let :price do
      PricingDecorator.new(stub(:pricing, :price_unit => 'yearly', :estimate => ''))
    end

    context 'for_rent' do
      before :each do
        price.pricing.stub(:for_rent?).and_return(true)
        price.pricing.stub(:for_rent_netto).and_return(2000)
      end

      it 'returns for_rent_netto' do
        price.price_to_be_displayed.should == '2 000.00'
      end

      context 'when estimate field is set' do
        before :each do
          price.pricing.stub(:estimate).and_return('Kannste nicht mieten')
        end

        it 'returns estimate field' do
          price.price_to_be_displayed.should == 'Kannste nicht mieten'
        end
      end
    end

    context 'for_sale' do
      before :each do
        price.pricing.stub(:for_rent?).and_return(false)
        price.pricing.stub(:for_sale).and_return(3000)
      end

      it 'returns for_rent_netto' do
        price.price_to_be_displayed.should == '3 000.00'
      end

      context 'when estimate field is set' do
        before :each do
          price.pricing.stub(:estimate).and_return('Kannste nicht kaufen')
        end

        it 'returns estimate field' do
          price.price_to_be_displayed.should == 'Kannste nicht kaufen'
        end
      end
    end
  end

  describe '#chapter "Preise/Bezug"' do
    describe 'key "Bezug"' do
      before :each do
        @real_estate = Fabricate(:published_real_estate,
          category: Fabricate(:category),
          pricing: Fabricate.build(:pricing, display_estimated_available_from: '')
        )
        @pricing_decorator = PricingDecorator.new(@real_estate.pricing)
      end

      context 'display_estimated_available_from is set' do
        it 'returns the display_estimated_available_from value' do
          @real_estate.pricing.display_estimated_available_from = 'Sommer 2014'
          expect(@pricing_decorator.chapter()[:content].last[:value]).to eq 'Sommer 2014'
        end
      end

      context 'display_estimated_available_from is not set' do
        it 'returns the available_from value' do
          expect(@pricing_decorator.chapter()[:content].last[:value]).to eq '01.01.2012'
        end
      end
    end
  end
end
