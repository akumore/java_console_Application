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
    [@offer, @utilization, model.model_name, field].join('.')
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

    )
  end
end
