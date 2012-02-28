require 'spec_helper'

describe RealEstateDecorator do
  describe 'an invalid real estate' do
    before :each do
      real_estate = RealEstate.new
      @decorator = RealEstateDecorator.new(real_estate)
    end

    [
      :full_address,
      :quick_infos,
      :description,
      :mini_doku_link,
      :quick_price_infos,
      :information_shared,
      :information_basic,
      :price_info_basic,
      :price_info_parking,
      :facts_and_figures,
      :infrastructure_parking,
      :infrastructure_distances
    ].each do |accessor|
      it "calling #{accessor} doesnt raise an exception with invalid data" do
        expect { @decorator.send(accessor) }.to_not raise_error
      end
    end
  end

  describe 'a valid real estate' do
    before :each do
      real_estate = Fabricate(:real_estate,
        :category => Fabricate(:category, :name=>'single_house', :label=>'Einfamilienhaus'),
        :reference => Reference.new,
        :address => Fabricate.build(:address),
        :information => Information.new,
        :pricing => Fabricate.build(:pricing),
        :figure => Fabricate.build(:figure),
        :infrastructure => Infrastructure.new,
        :description => Description.new
      )
      @decorator = RealEstateDecorator.new(real_estate)
    end

    [
      :information_shared,
      :information_basic,
      :price_info_basic,
      :price_info_parking,
      :facts_and_figures,
      :infrastructure_parking,
      :infrastructure_distances
    ].each do |accessor|
      it "#{accessor} returns an array of printable properties" do
        @decorator.send(accessor).should be_a(Array)
      end
    end
  end

end
