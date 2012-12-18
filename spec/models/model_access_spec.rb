require 'spec_helper'

describe ModelAccess do

  describe '#key_for' do
    it 'returns a concatenated key' do
      model_access = ModelAccess.new(Offer::RENT, Utilization::PARKING, ModelAccess.cms_blacklist)
      model_access.key_for('figures').should == 'rent.parking.figures'
    end
  end

  describe '#any_offer_key_for' do
    it 'returns a concatenated key with an offer placeholder' do
      model_access = ModelAccess.new(Offer::RENT, Utilization::PARKING, ModelAccess.cms_blacklist)
      model_access.any_offer_key_for('figures').should == '*.parking.figures'
    end
  end

  describe '#accessible?' do
    context 'when the key is in the blacklist' do
      it 'returns false' do
        model_access = ModelAccess.new(Offer::RENT, Utilization::LIVING, %w(rent.living.infrastructure))
        model_access.accessible?('infrastructure').should be_false
      end
    end

    context 'when the key is not in the blacklist' do
      it 'returns true' do
        model_access = ModelAccess.new(Offer::SALE, Utilization::PARKING, %w(sale.living.pricing))
        model_access.accessible?('pricing').should be_true
      end
    end
  end

  describe '.cms_blacklist' do
    context 'parking' do
      let :model_access do
        ModelAccess.new(Offer::RENT, Utilization::PARKING, ModelAccess.cms_blacklist)
      end

      describe 'real estate' do
        it 'is accessible' do
          model_access.accessible?(:real_estate).should be_true
        end
      end

      describe 'address' do
        it 'is accessible' do
          model_access.accessible?(:address).should be_true
        end
      end

      describe 'information' do
        it 'is accessible' do
          model_access.accessible?(:information).should be_true
        end
      end

      describe 'pricing' do
        it 'is accessible' do
          model_access.accessible?(:pricing).should be_true
        end
      end

      describe 'figure' do
        it 'is not accessible' do
          model_access.accessible?(:figure).should be_false
        end
      end

      describe 'infrastructure' do
        it 'is not accessible' do
          model_access.accessible?(:infrastructure).should be_false
        end
      end

      describe 'additional descriptions' do
        it 'is not accessible' do
          model_access.accessible?(:additional_description).should be_false
        end
      end

      describe 'images' do
        it 'is accessible' do
          model_access.accessible?(:media_asset).should be_true
        end
      end

    end
  end

end
