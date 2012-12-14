require 'spec_helper'

describe PriceUnit do
  describe '.all_by_offer_and_utilization' do
    context 'for rent' do
      it 'returns all price units' do
        all = PriceUnit.all_by_offer_and_utilization(Offer::RENT, Utilization::WORKING)
        all.should == %w(monthly yearly weekly daily year_m2)
      end

      context 'for parking' do
        it 'returns only monthly' do
          all = PriceUnit.all_by_offer_and_utilization(Offer::RENT, Utilization::PARKING)
          all.should == %w(monthly)
        end
      end
    end

    context 'for sale' do
      it 'returns all price units' do
        all = PriceUnit.all_by_offer_and_utilization(Offer::SALE, Utilization::WORKING)
        all.should == %w(sell sell_m2)
      end

      context 'for parking' do
        it 'returns only sell' do
          all = PriceUnit.all_by_offer_and_utilization(Offer::SALE, Utilization::PARKING)
          all.should == %w(sell)
        end
      end
    end
  end
end
