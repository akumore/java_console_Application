require 'spec_helper'

describe Pricing do
  describe '#initialize' do
    let :pricing do
      p = Pricing.new
      p.stub(:for_rent?).and_return(true)
      p.stub(:for_sale?).and_return(false)
      p.stub(:parking?).and_return(false)
      p
    end

    context 'without values' do
      it 'does not pass validations' do
        pricing.should_not be_valid
      end

      context 'for rent' do
        it 'requires a price unit' do
          pricing.should have(2).error_on(:price_unit)
        end

        it 'requires a "rent" price unit ' do
          pricing.price_unit = 'anything'
          pricing.should have(1).error_on(:price_unit)
        end

        it 'requires a netto rent price' do
          pricing.should have(2).error_on(:for_rent_netto)
        end

        it 'requires the rent extras' do
          pricing.should have(1).error_on(:for_rent_extra)
        end

        it 'has 6 errors' do
          pricing.valid?
          pricing.errors.should have(5).items
        end

        context 'parking' do
          before do
            pricing.stub(:parking?).and_return(true)
            pricing.stub_chain(:_parent, :offer).and_return(Offer::RENT)
            pricing.stub_chain(:_parent, :utilization).and_return(Utilization::PARKING)
          end

          it 'must be monthly' do
            pricing.price_unit = 'daily'
            pricing.should have(1).error_on(:price_unit)
          end
        end
      end

      context 'for sale' do
        before do
          pricing.stub(:for_rent?).and_return(false)
          pricing.stub(:for_sale?).and_return(true)
        end

        it 'does require a price_unit' do
          pricing.should have(2).error_on(:price_unit)
        end

        it 'requires a "sell" price unit ' do
          pricing.price_unit = 'something_invalid'
          pricing.should have(1).error_on(:price_unit)
        end

        it 'requires a sale price' do
          pricing.should have(2).error_on(:for_sale)
        end

        it 'has 4 errors' do
          pricing.valid?
          pricing.errors.should have(4).items
        end

        context 'parking' do
          before do
            pricing.stub(:parking?).and_return(true)
            pricing.stub_chain(:_parent, :offer).and_return(Offer::SALE)
            pricing.stub_chain(:_parent, :utilization).and_return(Utilization::PARKING)
          end

          it 'must be selling price' do
            pricing.price_unit = 'sell_m2'
            pricing.should have(1).error_on(:price_unit)
          end
        end
      end
    end
  end

  describe '#for_rent_brutto' do
    it 'calculates the gross rent price from the netto and the rent extra' do
      pricing = Pricing.new(:for_rent_netto => 1020, :for_rent_extra => 120)
      pricing.for_rent_brutto.should be(1140)
    end
  end

  describe '#for_rent_extra_is_mandatory?' do
    let :pricing do
      Pricing.new.tap do |p|
        p.stub(:parking?).and_return(false)
        p.stub(:for_rent?).and_return(false)
        p.stub(:for_sale?).and_return(true)
      end
    end

    context 'when for sale' do
      it 'returns false' do
        pricing.for_rent_extra_is_mandatory?.should be_false
      end
    end

    context 'when for rent' do
      it 'returns true' do
        pricing.stub(:for_rent?).and_return(true)
        pricing.stub(:for_sale?).and_return(false)
        pricing.for_rent_extra_is_mandatory?.should be_true
      end

      context 'when for parking' do
        it 'returns false' do
          pricing.stub(:parking?).and_return(true)
          pricing.for_rent_extra_is_mandatory?.should be_false
        end
      end
    end
  end
end
