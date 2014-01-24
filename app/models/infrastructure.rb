class Infrastructure

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :inside_parking_spots, :type => Integer # Parkplatz in Autoeinstellhalle
  field :outside_parking_spots, :type => Integer # Parkplatz im Freien
  field :covered_slot, :type => Integer # Parkplatz im Freien überdacht
  field :covered_bike, :type => Integer # Motorrad-Parkplatz in Autoeinstellhalle
  field :outdoor_bike, :type => Integer # Motorrad-Parkplatz im Freien überdacht
  field :single_garage, :type => Integer # Einzelgarage
  field :double_garage, :type => Integer # Doppelgarage

  validates :inside_parking_spots,
            :outside_parking_spots,
            :covered_slot,
            :covered_bike,
            :outdoor_bike,
            :single_garage,
            :double_garage, :numericality => true, :allow_blank => true

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
