require 'spec_helper'
require 'google_analytics_category_translator'

describe GoogleAnalyticsCategoryTranslator do
  include GoogleAnalyticsCategoryTranslator

  let :real_estate do
    mock_model(RealEstate)
  end

  context 'for sale' do
    before do
      real_estate.stub(:offer).and_return(Offer::SALE)
    end

    context 'with living utilization' do
      it "returns 'Kaufen Wohnen'" do
        real_estate.stub(:utilization).and_return(Utilization::LIVING)
        expect(translate_category(real_estate)).to eq('Kaufen Wohnen')
      end
    end

    context 'with working utilization' do
      it "returns 'Kaufen Arbeiten'" do
        real_estate.stub(:utilization).and_return(Utilization::WORKING)
        expect(translate_category(real_estate)).to eq('Kaufen Arbeiten')
      end
    end

    context 'with storing utilization' do
      it "returns 'Kaufen Lagern'" do
        real_estate.stub(:utilization).and_return(Utilization::STORING)
        expect(translate_category(real_estate)).to eq('Kaufen Lagern')
      end
    end

    context 'with parking utilization' do
      it "returns 'Kaufen Parkieren'" do
        real_estate.stub(:utilization).and_return(Utilization::PARKING)
        expect(translate_category(real_estate)).to eq('Kaufen Parkieren')
      end
    end
  end

  context 'for rent' do
    before do
      real_estate.stub(:offer).and_return(Offer::RENT)
    end

    context 'with living utilization' do
      it "returns 'Mieten Wohnen'" do
        real_estate.stub(:utilization).and_return(Utilization::LIVING)
        expect(translate_category(real_estate)).to eq('Mieten Wohnen')
      end
    end

    context 'with working utilization' do
      it "returns 'Mieten Arbeiten'" do
        real_estate.stub(:utilization).and_return(Utilization::WORKING)
        expect(translate_category(real_estate)).to eq('Mieten Arbeiten')
      end
    end

    context 'with storing utilization' do
      it "returns 'Mieten Lagern'" do
        real_estate.stub(:utilization).and_return(Utilization::STORING)
        expect(translate_category(real_estate)).to eq('Mieten Lagern')
      end
    end

    context 'with parking utilization' do
      it "returns 'Mieten Parkieren'" do
        real_estate.stub(:utilization).and_return(Utilization::PARKING)
        expect(translate_category(real_estate)).to eq('Mieten Parkieren')
      end
    end
  end

  context 'with EN as locale' do
    before do
      I18n.locale = :en
      real_estate.stub(:offer).and_return(Offer::RENT)
    end

    context 'with living utilization' do
      it "returns 'Mieten Wohnen'" do
        real_estate.stub(:utilization).and_return(Utilization::LIVING)
        expect(translate_category(real_estate)).to eq('Mieten Wohnen')
      end
    end
  end
end
