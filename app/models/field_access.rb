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
    return false if @blacklist.include?(key_for(model, field))
    return false if @blacklist.include?(any_offer_key_for(model, field))
    return false if @blacklist.include?(any_utilization_key_for(model, field))
    true
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
       *.working.figure.specification_living_surface
       *.storing.figure.specification_living_surface
       *.parking.figure.specification_living_surface
       *.storing.figure.property_surface
       *.storing.figure.property_surface_estimate
       *.living.figure.usable_surface
       *.parking.figure.usable_surface
       *.living.figure.specification_usable_surface
       *.parking.figure.specification_usable_surface
       *.storing.figure.storage_surface
       *.parking.figure.storage_surface
       *.living.figure.usable_surface_estimate
       *.parking.figure.usable_surface_estimate
       *.parking.pricing.storage
       *.storing.pricing.storage
       *.parking.pricing.extra_storage
       *.storing.pricing.extra_storage
       *.parking.pricing.parking_spots_prices_group
       *.parking.real_estate.title
       *.parking.real_estate.utilization_description
       sale.*.information.rent_info
       rent.parking.information.rent_info
    )
  end
end
