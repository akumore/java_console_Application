class Pricing
  include Mongoid::Document
  include Mongoid::Timestamps

  #
  # Fields are used for _pricing partial of a real estate
  #
  PRICING_FIELDS = [
    :for_sale,
    :for_rent_netto,
    :additional_costs,
    :storage,
    :extra_storage,
    :inside_parking,
    :outside_parking,
    :covered_slot,
    :covered_bike,
    :outdoor_bike,
    :single_garage,
    :double_garage
  ]

  PARKING_PRICING_FIELDS = [
    :inside_parking,
    :outside_parking,
    :covered_slot,
    :covered_bike,
    :outdoor_bike,
    :single_garage,
    :double_garage
  ]

  embedded_in :real_estate

  field :for_rent_netto,   :type => Integer
  field :additional_costs, :type => Integer # Nebenkosten
  field :for_sale,         :type => Integer # Kaufpreis
  field :price_unit,       :type => String  # Pro Woche, Jahr, Monat, Einmalig
  field :storage,          :type => Integer # Lagerkosten
  field :extra_storage,    :type => Integer # Nebenkosten Lager
  field :estimate,         :type => String  # Geschätz, z.B. 200-500.-
  field :opted,            :type => Boolean, :default => false # Optiert, entscheidet ob MwST angezeigt wird

  # Preisfelder in zweiter Spalte, wenn PriceUnit => year_m2
  field :for_rent_netto_monthly,   :type => Integer
  field :additional_costs_monthly, :type => Integer # Nebenkosten pro Monat
  field :storage_monthly,          :type => Integer # Lagerkosten pro Monat
  field :extra_storage_monthly,    :type => Integer # Nebenkosten Lager pro Monat
  field :estimate_monthly,         :type => String  # Geschätz, z.B. 200-500.- pro Monat

  # Mietzins für Parkplätze
  field :inside_parking,  :type => Integer # Parkplatz in Autoeinstellhalle
  field :outside_parking, :type => Integer # Parkplatz im Freien
  field :covered_slot,    :type => Integer # Parkplatz im Freien überdacht
  field :covered_bike,    :type => Integer # Motorrad-Parkplatz in Autoeinstellhalle
  field :outdoor_bike,    :type => Integer # Motorrad-Parkplatz im Freien überdacht
  field :single_garage,   :type => Integer # Einzelgarage
  field :double_garage,   :type => Integer # Doppelgarage

  # Mietzins für Parkplätze (monthly)
  field :inside_parking_monthly,  :type => Integer
  field :outside_parking_monthly, :type => Integer
  field :covered_slot_monthly,    :type => Integer
  field :covered_bike_monthly,    :type => Integer
  field :outdoor_bike_monthly,    :type => Integer
  field :single_garage_monthly,   :type => Integer
  field :double_garage_monthly,   :type => Integer

  validates :for_rent_netto, :presence => true, :numericality => true, :if => :for_rent?
  validates :additional_costs, :presence => true, :if => :additional_costs_is_mandatory?
  validates :for_sale, :presence => true, :numericality => true, :if => :for_sale?

  validates :additional_costs,
            :storage,
            :extra_storage,
            :storage_monthly,
            :extra_storage_monthly,
            :estimate_monthly,
            :inside_parking,
            :outside_parking,
            :covered_slot,
            :covered_bike,
            :outdoor_bike,
            :single_garage,
            :double_garage,
            :inside_parking_monthly,
            :outside_parking_monthly,
            :covered_slot_monthly,
            :covered_bike_monthly,
            :outdoor_bike_monthly,
            :single_garage_monthly,
            :double_garage_monthly,
            :numericality => true, :allow_blank => true

  validates :price_unit, :presence => true, :inclusion => PriceUnit.for_sale, :if => :for_sale?
  validates :price_unit, :presence => true, :inclusion => PriceUnit.for_rent, :if => :for_rent?
  validates :price_unit, :presence => true,
                         :inclusion => {
                            :in => lambda{ |p| p.allowed_price_units }
                          },
                         :if => :parking?

  validates :for_rent_netto_monthly,
    :presence => true,
    :numericality => true,
    :if => :for_rent? && :price_unit_is_per_square_meter_per_year?
  validates :additional_costs_monthly,
    :presence => true,
    :if => :for_rent? && :price_unit_is_per_square_meter_per_year?,
    :unless => :parking?

  delegate :for_sale?,
           :for_rent?,
           :private_utilization?,
           :living?,
           :working?,
           :parking?,
           :storing?, :to => :_parent

  def for_rent_brutto
    for_rent_netto.to_i + additional_costs.to_i
  end

  def allowed_price_units
    PriceUnit.all_by_offer_and_utilization(_parent.offer, _parent.utilization)
  end

  def additional_costs_is_mandatory?
    for_rent? && !parking?
  end

  def price_unit_is_per_square_meter_per_year?
    price_unit == PriceUnit.per_square_meter_per_year
  end
end
