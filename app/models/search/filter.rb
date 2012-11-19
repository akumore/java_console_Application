module Search
  class Filter

    include Offer::Accessors
    include Utilization::Accessors

    include ActiveModel::Conversion
    extend ActiveModel::Translation

    class CantonsCitiesMap < Hash

      alias_method :available_cantons, :keys

      def available_cities
        values.flatten
      end
    end

    attr_accessor :offer, :utilization, :cantons, :cities, :sort_field, :sort_order
    attr_reader :cantons_cities_map

    delegate :available_cantons, :available_cities, :to => :cantons_cities_map

    def initialize(params={})
      params.each do |key, value|
        send("#{key}=", value.presence)
      end

      @offer ||= Offer::RENT
      @utilization = default_utilization(utilization)
      @cities ||= []
      @cantons ||= []
      @cantons_cities_map = init_cantons_cities_map

      @sort_fields = SortFields.new(utilization)
      @sort_field = @sort_fields.fields.include?(sort_field) ? sort_field : Defaults.new(utilization).sort_field

      @sort_order = %w(asc desc).include?(sort_order) ? sort_order : 'desc'
    end

    def persisted?
      false
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

    def to_query_hash
      {:offer => offer, :utilization => utilization}.tap do |h|
        h['address.canton'] = {"$in" => cantons} unless cantons.empty?
        h['address.city'] = {"$in" => cities} unless cities.empty?
      end
    end

    def to_query_order_array
      [@sort_fields.get_database_key(sort_field), sort_order]
    end

    private

    def default_utilization(utilization)
      if utilization == Utilization::LIVING && RealEstate.living.count > 0
        Utilization::LIVING
      elsif utilization == Utilization::WOKRING && RealEstate.working.count > 0
        Utilization::WOKRING
      elsif utilization == Utilization::STORAGE && RealEstate.storage.count > 0
        Utilization::STORAGE
      elsif utilization == Utilization::PARKING && RealEstate.parking.count > 0
        Utilization::PARKING
      else
        Utilization::LIVING
      end
    end

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
end
