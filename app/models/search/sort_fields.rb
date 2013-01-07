module Search
  class SortFields

    attr_reader :fields

    def initialize(utilization)
      @fields = {
        Utilization::LIVING => %w(rooms price available_from category)
        # add more cases here
      }.fetch(utilization.presence, %w(usable_surface floor price available_from))
    end

    def get_database_key(field)
      {
        'rooms' => 'figure.rooms',
        'price' => 'pricing.for_rent_netto',
        'available_from' => 'information.available_from',
        'category' => 'category_label',
        'usable_surface' => 'figure.usable_surface',
        'floor' => 'figure.floor'
      }.fetch(field)
    end

  end
end