class Pricing
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :for_rent_netto, :type => Integer
  field :for_rent_extra, :type => Integer # Nebenkosten
  field :for_rent_depot, :type => Integer
  field :for_sale, :type => Integer # Kaufpreis
  field :price_unit, :type => String # Pro Woche, Jahr, Monat, Einmalig
  field :storage, :type => Integer # Lagerkosten
  field :extra_storage, :type => Integer # Nebenkosten Lager
  field :estimate, :type => String # Geschätz, z.B. 200-500.-
  field :opted, :type => Boolean # Optiert, entscheidet ob MwST angezeigt wird

  # Mietzins für Parkplätze
  field :rental_price_double_garage, :type => Integer # Doppelgarage
  field :rental_price_single_garage, :type => Integer # Einzelgarage
  field :rental_price_outdoor_bike, :type => Integer # Motorrad-Parkplatz im Freien überdacht
  field :rental_price_covered_bike, :type => Integer # Motorrad-Parkplatz in Autoeinstellhalle
  field :outside_parking, :type => Integer # Parkplatz im Freien
  field :rental_price_covered_slot, :type => Integer # Parkplatz im Freien überdacht
  field :inside_parking, :type => Integer # Parkplatz in Autoeinstellhalle

  validates :for_rent_netto, :presence => true, :numericality => true, :if => :for_rent?
  validates :for_rent_extra, :presence => true, :if => :for_rent_extra_is_mandatory?
  validates :for_rent_extra, :numericality => true, :if => :for_rent?
  validates :for_sale, :presence => true, :numericality => true, :if => :for_sale?

  validates :storage,
            :extra_storage,
            :rental_price_double_garage,
            :rental_price_single_garage,
            :rental_price_outdoor_bike,
            :rental_price_covered_bike,
            :outside_parking,
            :rental_price_covered_slot,
            :inside_parking, :numericality => true, :allow_blank => true

  validates :price_unit, :presence => true, :inclusion => PriceUnit.for_sale, :if => :for_sale?
  validates :price_unit, :presence => true, :inclusion => PriceUnit.for_rent, :if => :for_rent?
  validates :price_unit, :presence => true,
                         :inclusion => {
                            :in => lambda{ |p| p.allowed_price_units }
                          },
                         :if => :parking?

  delegate :for_sale?, :for_rent?, :private_utilization?, :parking?, :to => :_parent

  def for_rent_brutto
    for_rent_netto.to_i + for_rent_extra.to_i
  end

  def allowed_price_units
    PriceUnit.all_by_offer_and_utilization(_parent.offer, _parent.utilization)
  end

  def for_rent_extra_is_mandatory?
    for_rent? && !parking?
  end
end
