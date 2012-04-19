class Pricing
  include Mongoid::Document
  include Mongoid::Timestamps

  PRICE_UNITS = %w(month year week once)

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

  validates :for_rent_netto, :presence => true, :if => :for_rent?
  validates :for_rent_extra, :presence => true, :if => :for_rent?
  validates :for_sale, :presence => true, :if => :for_sale?
  validates :price_unit, :presence => true, :if => :for_rent?

  delegate :for_sale?, :for_rent?, :to => :_parent

end
