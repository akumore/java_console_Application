class Pricing
  include Mongoid::Document
  include Mongoid::Timestamps

  PRICE_UNITS_FOR_RENT = %w(monthly yearly weekly daily year_m2)
  PRICE_UNITS_FOR_SALE = %w(sell sell_m2)
  PRICE_UNITS = PRICE_UNITS_FOR_RENT + PRICE_UNITS_FOR_SALE

  embedded_in :real_estate

  field :for_rent_netto, :type => Integer
  field :for_rent_extra, :type => Integer # Nebenkosten
  field :for_rent_depot, :type => Integer
  field :for_sale, :type => Integer # Kaufpreis
  field :price_unit, :type => String # Pro Woche, Jahr, Monat, Einmalig
  field :inside_parking, :type => Integer # Pro Parkplatz in Autoeinstellhalle
  field :outside_parking, :type => Integer # Pro Parkplatz nicht überdacht
  field :inside_parking_temporary, :type => Integer # Pro Parkplatz in Autoeinstellhalle temporär
  field :outside_parking_temporary, :type => Integer # Pro Parkplatz nicht überdacht temporär
  field :storage, :type => Integer # Lagerkosten
  field :extra_storage, :type => Integer # Nebenkosten Lager
  field :estimate, :type => String # Geschätz, z.B. 200-500.-
  field :opted, :type => Boolean # Optiert, entscheidet ob MwST angezeigt wird

  validates :for_rent_netto, :presence => true, :numericality => true, :if => :for_rent?
  validates :for_rent_extra, :presence => true, :numericality => true, :if => :for_rent?
  validates :for_sale, :presence => true, :numericality => true, :if => :for_sale?

  validates :inside_parking, :outside_parking, :inside_parking_temporary,
            :outside_parking_temporary, :storage, :extra_storage, :numericality => true, :allow_blank => true

  validates :price_unit, :presence => true, :inclusion => PRICE_UNITS_FOR_SALE, :if => :for_sale?
  validates :price_unit, :presence => true, :inclusion => PRICE_UNITS_FOR_RENT, :if => :for_rent?

  delegate :for_sale?, :for_rent?, :private_utilization?, :to => :_parent

  def for_rent_brutto
    for_rent_netto.to_i + for_rent_extra.to_i
  end
end
