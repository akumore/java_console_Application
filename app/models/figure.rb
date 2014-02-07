# encoding: utf-8

class Figure
  include Mongoid::Document
  include Mongoid::Timestamps

  SPECIFICATION_LIVING_SURFACE_TEXT = 'Fläche exklusive Fassaden-, Treppenhaus-, Wohnungstrennwände, Leitungsschächte und Balkon/Terrasse. Fläche inklusive Innenwände.'
  SPECIFICATION_USABLE_SURFACE_TEXT = 'Fläche exklusive Aussen-, Treppenhauswände und Leitungsschächte. Trennwände zwischen den Mietern sind hälftig enthalten.'
  SPECIFICATION_USABLE_SURFACE_WITH_TOILET_TEXT = 'Fläche exklusive Fassaden-, Treppenhauswände, Leitungsschächte und Balkon/Terrasse. Trennwände zwischen den Mietern sind hälftig und gemeinsame WC-Anlagen anteilsmässig enthalten.'
  SPECIFICATION_USABLE_SURFACE_WITHOUT_TOILET_TEXT = 'Fläche exklusive Fassaden-, Treppenhauswände, Leitungsschächte und Balkon/Terrasse. Trennwände zwischen den Mietern sind hälftig enthalten.'

  embedded_in :real_estate

  field :floor, :type => Integer
  field :floor_estimate, :type => String # 1-5 Stock
  field :rooms, :type => String #
  field :rooms_estimate, :type => String # 3-5 Zimmer

  field :living_surface, :type => Integer
  field :living_surface_estimate, :type => String # 50-80 Quadratmeter
  field :specification_living_surface, :type => String, :default => SPECIFICATION_LIVING_SURFACE_TEXT # Spezifikation Wohnfläche
  field :property_surface, :type => String # Grundstückfläche
  field :property_surface_estimate, :type => String # Grundstückfläche ungefähr
  field :usable_surface, :type => Integer # Nutzfläche
  field :usable_surface_estimate, :type => String # Nutzfläche ungefähr

  # Spezifikation Bruttonutzfläche
  field :specification_usable_surface_toilet, :type => Boolean
  field :specification_usable_surface, :type => String, :default => SPECIFICATION_USABLE_SURFACE_TEXT
  field :specification_usable_surface_with_toilet, :type => String, :default => SPECIFICATION_USABLE_SURFACE_WITH_TOILET_TEXT
  field :specification_usable_surface_without_toilet, :type => String, :default => SPECIFICATION_USABLE_SURFACE_WITHOUT_TOILET_TEXT

  field :storage_surface, :type => String # Lagerfläche
  field :storage_surface_estimate, :type => String # Lagerfläche ungefähr

  field :inside_parking_spots, :type => Integer # Parkplatz in Autoeinstellhalle
  field :outside_parking_spots, :type => Integer # Parkplatz im Freien
  field :covered_slot, :type => Integer # Parkplatz im Freien überdacht
  field :covered_bike, :type => Integer # Motorrad-Parkplatz in Autoeinstellhalle
  field :outdoor_bike, :type => Integer # Motorrad-Parkplatz im Freien überdacht
  field :single_garage, :type => Integer # Einzelgarage
  field :double_garage, :type => Integer # Doppelgarage
  field :offer_html, :type => String

  # fields which must be numeric
  validates :property_surface,
            :inside_parking_spots,
            :outside_parking_spots,
            :covered_slot,
            :covered_bike,
            :outdoor_bike,
            :single_garage,
            :double_garage,
            :numericality => true,
            :allow_blank => true

  # fields which must be numeric, but only if private
  validates :living_surface,
            :numericality => true,
            :allow_blank => true,
            :if => :living?

  # storage surface must be numeric, but only if working or living
  validates :storage_surface,
            :numericality => true,
            :allow_blank => true,
            :if => :working? || :living?

  # fields which must be present and numeric, but only if private
  validates :rooms,
            :presence => true,
            :numericality => true,
            :if => :living?

  # fields which must be present and numeric, but only if commercial
  validates :usable_surface,
            :presence => true,
            :numericality => true,
            :if => :working? || :storing?

  validates :floor,
            :presence => true,
            :numericality => true,
            :unless => :parking?

  delegate :commercial_utilization?, :private_utilization?, :to => :_parent
  delegate :working?, :living?, :parking?, :storing?, :to => :_parent

  def has_roofed_parking_spot
    self.inside_parking_spots.to_i > 0 ||
    self.covered_slot.to_i > 0 ||
    self.covered_bike.to_i > 0 ||
    self.outdoor_bike.to_i > 0 ||
    self.single_garage.to_i > 0 ||
    self.double_garage.to_i > 0
  end

  def has_roofed_parking_spot?
    has_roofed_parking_spot
  end

  def has_garage
    self.inside_parking_spots.to_i > 0 ||
    self.covered_bike.to_i > 0 ||
    self.single_garage.to_i > 0 ||
    self.double_garage.to_i > 0
  end

  def has_garage?
    has_garage
  end

  def has_parking_spot
    self.outside_parking_spots.to_i > 0
  end

  def has_parking_spot?
    has_parking_spot
  end

end
