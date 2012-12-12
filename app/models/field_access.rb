class FieldAccess

  attr_reader :model_class,
              :offer,
              :utilization,
              :blacklist

  def initialize(offer, utilization, blacklist = [])
    @offer = map_offer(offer)
    @utilization = map_utilization(utilization)
    @blacklist = blacklist
  end

  def accessible?(model, field)
    found = if @blacklist.include?(key_for(model, field))
      true
    elsif @blacklist.include?(any_offer_key_for(model, field))
      true
    elsif @blacklist.include?(any_utilization_key_for(model, field))
      true
    else
      false
    end
    !found
  end

  def key_for(model, field)
    [@offer, @utilization, model.class.name.underscore, field].join('.')
  end

  def any_offer_key_for(model, field)
    ['*', @utilization, model.class.name.underscore, field].join('.')
  end

  def any_utilization_key_for(model, field)
    [@offer, '*', model.class.name.underscore, field].join('.')
  end

  private

  def map_offer(name)
    {
      Offer::RENT => 'rent',
      Offer::SALE => 'sale'
    }[name]
  end

  def map_utilization(name)
    {
      Utilization::LIVING => 'living',
      Utilization::WORKING => 'working',
      Utilization::STORING => 'storing',
      Utilization::PARKING => 'parking'
    }[name]
  end

  def self.cms_blacklist
    %w(
       *.working.figure.rooms
       *.parking.figure.rooms
       *.storing.figure.rooms
       *.working.figure.rooms_estimate
       *.storing.figure.rooms_estimate
       *.parking.figure.rooms_estimate
       *.working.figure.living_surface
       *.storing.figure.living_surface
       *.parking.figure.living_surface
       *.working.figure.living_surface_estimate
       *.storing.figure.living_surface_estimate
       *.parking.figure.living_surface_estimate
       *.living.figure.usable_surface
       *.storing.figure.usable_surface
       *.parking.figure.usable_surface
       *.living.figure.storage_surface
       *.storing.figure.storage_surface
       *.parking.figure.storage_surface
       *.living.figure.usable_surface_estimate
       *.storing.figure.usable_surface_estimate
       *.parking.figure.usable_surface_estimate
       *.living.figure.ceiling_height
       *.storing.figure.ceiling_height
       *.parking.figure.ceiling_height
       *.parking.pricing.for_rent_depot
       *.parking.pricing.parking_spots_prices_group
    )
  end
end
