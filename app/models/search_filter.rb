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
    params[:sort_order] ||= ''
    params[:sort_field] ||= ''
    super
    @cantons_cities_map = init_cantons_cities_map

    self.sort_order = sanitize_sort_order(params[:sort_order])
    self.sort_field = sanitize_sort_field(params[:sort_field])
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
    {
      :offer => offer,
      :utilization => utilization,
      :cantons => cantons,
      :cities => cities,
      :sort_order => sort_order,
      :sort_field => sort_field
    }
  end

  def available_sort_fields
    if NON_COMMERCIAL == utilization
      %w(rooms price available_from category)
    else
      %w(usable_surface floor price available_from)
    end
  end

  def available_sort_orders
    %w(asc desc)
  end

  def to_query_hash
    {:offer => offer, :utilization => utilization}.tap do |h|
      h['address.canton'] = {"$in" => cantons} unless cantons.empty?
      h['address.city'] = {"$in" => cities} unless cities.empty?
    end
  end

  def to_query_order_array
    [actual_sort_field(sort_field), sort_order]
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

  def actual_sort_field field
    {
      'rooms' => 'figure.rooms',
      'price' => 'pricing.for_rent_netto',
      'available_from' => 'information.available_from',
      'category' => 'category.name',
      'usable_surface' => 'figure.usable_surface',
      'floor' => 'figure.floor'
    }[field]
  end

  def sanitize_sort_field field
    if available_sort_fields.include? field
      field
    else
      if utilization == COMMERCIAL
        'usable_surface'
      else
        'rooms'
      end
    end
  end

  def sanitize_sort_order order
    if available_sort_orders.include? order
      order
    else
      'desc'
    end
  end

end
