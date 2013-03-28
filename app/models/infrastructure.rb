class Infrastructure

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate
  embeds_many :points_of_interest, :class_name => 'PointOfInterest'

  accepts_nested_attributes_for :points_of_interest, :reject_if => proc { |attributes| attributes['distance'].blank? }

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

  def build_points_of_interest(real_estate)
    if real_estate.parking? || real_estate.storing?
      build_parking_storing_points_of_interest
    else
      build_all_points_of_interest
    end
  end

  def build_all_points_of_interest
    PointOfInterest::TYPES.each do |name|
      self.points_of_interest.find_or_initialize_by :name => name
    end
  end

  def build_parking_storing_points_of_interest
    PointOfInterest::PARKING_STORING_TYPES.each do |name|
      self.points_of_interest.find_or_initialize_by :name => name
    end
  end

  def has_roofed_parking_spot
    self.inside_parking_spots.to_i > 0
  end

  def has_roofed_parking_spot?
    has_roofed_parking_spot
  end

  def has_garage
    self.inside_parking_spots.to_i > 0
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
