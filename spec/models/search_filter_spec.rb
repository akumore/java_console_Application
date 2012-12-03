require 'spec_helper'

describe SearchFilter do

  it 'defaults to offer type RENT' do
    SearchFilter.new.offer.should == RealEstate::OFFER_FOR_RENT
  end

  it 'defaults to utilization type NON_COMMERCIAL' do
    SearchFilter.new.utilization.should == RealEstate::UTILIZATION_PRIVATE
  end

  it 'defaults to empty array if no cities submitted' do
    SearchFilter.new.cities.should be_empty
  end

  it 'defaults to empty array if no cantons submitted' do
    SearchFilter.new.cantons.should be_empty
  end

  it 'defaults to descending sort order' do
    SearchFilter.new.sort_order.should == 'desc'
  end

  context 'for commercial utilization' do
    it 'defaults to search_field usable_surface' do
      SearchFilter.new(:utilization => RealEstate::UTILIZATION_COMMERICAL).sort_field.should == 'usable_surface'
    end
  end

  context 'for private utilization' do
    it 'defaults to search_field rooms' do
      SearchFilter.new(:utilization => RealEstate::UTILIZATION_PRIVATE).sort_field.should == 'rooms'
    end
  end

  describe 'Canton-City-Map' do
    before do
      @arth = Fabricate :published_real_estate,
                        :offer => RealEstate::OFFER_FOR_RENT,
                        :utilization => RealEstate::UTILIZATION_PRIVATE,
                        :address => Fabricate.build(:address, :canton => 'sz', :city => 'Arth'),
                        :category => Fabricate(:category)

      @fahrwangen = Fabricate :published_real_estate,
                              :offer => RealEstate::OFFER_FOR_SALE,
                              :utilization => RealEstate::UTILIZATION_PRIVATE,
                              :address => Fabricate.build(:address, :canton => 'ag', :city => 'Fahrwangen'),
                              :category => Fabricate(:category)
    end

    let :filter do
      # Using late initialization of this filter within tests
      SearchFilter.new(:offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE)
    end

    it 'filters real estate by offer and utilization' do
      filter.cantons_cities_map.size.should == 1
    end

    it 'contains the cantons of all matching real estates' do
      filter.available_cantons.should == [@arth.address.canton]
    end

    it 'contains the cities of all matching real estates' do
      filter.available_cities.should == [@arth.address.city]
    end

    it 'groups cities by canton' do
      @fahrwangen.update_attribute :offer, RealEstate::OFFER_FOR_RENT
      filter.cantons_cities_map.should == {'sz' => ['Arth'], 'ag' => ['Fahrwangen']}
    end

    it 'uses on web-channel published real_estates only' do
      # excluded because of state 'editing'
      unpublished = Fabricate :real_estate,
                              :state => 'editing',
                              :offer => RealEstate::OFFER_FOR_RENT,
                              :utilization => RealEstate::UTILIZATION_PRIVATE,
                              :channels => [RealEstate::WEBSITE_CHANNEL],
                              :address => Fabricate.build(:address, :canton => 'zg', :city => 'Steinhausen'),
                              :category => Fabricate(:category)
      # excluded because of channel
      @arth.update_attribute :channels, []
      @fahrwangen.update_attribute :offer, RealEstate::OFFER_FOR_RENT

      filter.available_cantons.should == [@fahrwangen.address.canton]
      filter.available_cities.should == [@fahrwangen.address.city]
    end

  end

  describe 'Converting filter' do
    before do
      @filter = SearchFilter.new(
        :offer => RealEstate::OFFER_FOR_RENT,
        :utilization => RealEstate::UTILIZATION_PRIVATE,
        :cities => ['Arth', 'Fahrwangen'],
        :sort_field => 'price',
        :sort_order => 'asc'
      )
    end

    it 'converts filter state into a (params) hash' do
      @filter.to_params.should == {:cities => ['Arth', 'Fahrwangen'], :cantons => [],
                                   :offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE,
                                   :sort_field => 'price',
                                   :sort_order => 'asc'
                                 }
    end

    it 'converts filter state into hash that can be used for querying database' do
      @filter.to_query_hash.should == {:offer => RealEstate::OFFER_FOR_RENT, :utilization => RealEstate::UTILIZATION_PRIVATE,
                                       'address.city' => {"$in" => ['Arth', 'Fahrwangen']}
      }
    end

    it 'converts filter state into array that can be used for sorting on the database' do
      @filter.to_query_order_array == ['price', 'asc']
    end
  end

  describe '#sortable?' do
    context 'when the utilization is parking' do
      it 'returns false' do
        sf = SearchFilter.new(:utilization => RealEstate::UTILIZATION_PARKING)
        sf.sortable?.should be_false
      end
    end

    context 'when the utilization is living' do
      it 'returns true' do
        sf = SearchFilter.new(:utilization => RealEstate::UTILIZATION_PRIVATE)
        sf.sortable?.should be_true
      end
    end

    context 'when the utilization is storing' do
      it 'returns true' do
        sf = SearchFilter.new(:utilization => RealEstate::UTILIZATION_COMMERICAL)
        sf.sortable?.should be_true
      end
    end

    context 'when the utilization is c' do
      it 'returns true' do
        sf = SearchFilter.new(:utilization => RealEstate::UTILIZATION_STORAGE)
        sf.sortable?.should be_true
      end
    end
  end
end
