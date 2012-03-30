class SearchFilter < OpenStruct
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  class CantonsCitiesMap < Hash

    alias_method :available_cantons, :keys

    def available_cities
      values.flatten
    end
  end

  #attr_accessor :offer, :utilization, :cantons, :cities
  attr_reader :cantons_cities_map

  SALE = RealEstate::OFFER_FOR_SALE
  RENT = RealEstate::OFFER_FOR_RENT

  NON_COMMERCIAL =  RealEstate::UTILIZATION_PRIVATE
  COMMERCIAL = RealEstate::UTILIZATION_COMMERICAL

  delegate :available_cantons, :available_cities, :to => :cantons_cities_map

  def initialize(params={})
    params[:offer] ||= RENT
    params[:utilization] ||= NON_COMMERCIAL
    params[:cities] ||= []
    params[:cantons] ||= []
    super
    @cantons_cities_map = init_cantons_cities_map
  end

  def persisted?
    false
  end

  def for_rent?
    offer == RENT
  end

  def for_sale?
    offer == SALE
  end

  def commercial?
    utilization == COMMERCIAL
  end

  def to_params
    {:offer => offer, :utilization => utilization, :cantons=>cantons, :cities=>cities}
  end

  def to_query_hash
    {:offer => offer, :utilization => utilization}.tap do |h|
      h['address.canton'] = {"$in" => cantons} unless cantons.empty?
      h['address.city'] = {"$in" => cities} unless cities.empty?
    end
  end


  private
  def init_cantons_cities_map
    addresses = RealEstate.published.web_channel.where(:offer=>offer, :utilization=>utilization).map(&:address).compact
    addresses.inject(CantonsCitiesMap.new) do |map, address|
      canton = address.canton.downcase
      map[canton] ||= []
      map[canton] << address.city
      map[canton].uniq!
      map
    end
  end

end