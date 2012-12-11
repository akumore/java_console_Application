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
    !(@blacklist.include?(key_for(model, field)))
  end

  def key_for(model, field)
    [@offer, @utilization, model.class.name.underscore, field].join('.')
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
       rent.working.figure.rooms
       rent.working.figure.rooms_estimate
       rent.working.figure.living_surface
       rent.working.figure.living_surface_estimate
       rent.storing.figure.rooms
       rent.storing.figure.rooms_estimate
       rent.storing.figure.living_surface
       rent.storing.figure.living_surface_estimate
       rent.parking.figure.rooms
       rent.parking.figure.rooms_estimate
       rent.parking.figure.living_surface
       rent.parking.figure.living_surface_estimate
       sale.working.figure.rooms
       sale.working.figure.rooms_estimate
       sale.working.figure.living_surface
       sale.working.figure.living_surface_estimate
       sale.storing.figure.rooms
       sale.storing.figure.rooms_estimate
       sale.storing.figure.living_surface
       sale.storing.figure.living_surface_estimate
       sale.parking.figure.rooms
       sale.parking.figure.rooms_estimate
       sale.parking.figure.living_surface
       sale.parking.figure.living_surface_estimate
       rent.living.figure.usable_surface
       rent.living.figure.usable_surface_estimate
       rent.living.figure.storage_surface
       rent.living.figure.ceiling_height
       rent.storing.figure.usable_surface
       rent.storing.figure.usable_surface_estimate
       rent.storing.figure.storage_surface
       rent.storing.figure.ceiling_height
       ret.parking.figure.usable_surface
       ret.parking.figure.usable_surface_estimate
       ret.parking.figure.storage_surface
       ret.parking.figure.ceiling_height
       sale.living.figure.usable_surface
       sale.living.figure.usable_surface_estimate
       sale.living.figure.storage_surface
       sale.living.figure.ceiling_height
       sale.storing.figure.usable_surface
       sale.storing.figure.usable_surface_estimate
       sale.storing.figure.storage_surface
       sale.storing.figure.ceiling_height
       sale.parking.figure.usable_surface
       sale.parking.figure.usable_surface_estimate
       sale.parking.figure.storage_surface
       sale.parking.figure.ceiling_height
    )
  end
end
