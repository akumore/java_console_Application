class Infrastructure

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate
  embeds_many :points_of_interest, :class_name => 'PointOfInterest'

  accepts_nested_attributes_for :points_of_interest, :reject_if => proc { |attributes| attributes['distance'].blank? }

  field :has_roofed_parking_spot, :type => Boolean
  field :inside_parking_spots, :type => Integer
  field :outside_parking_spots, :type => Integer
  field :inside_parking_spots_temporary, :type => Integer
  field :outside_parking_spots_temporary, :type => Integer

  validates :inside_parking_spots, :outside_parking_spots, :inside_parking_spots_temporary,
            :outside_parking_spots_temporary, :numericality => true, :allow_blank => true

  def build_all_points_of_interest
    PointOfInterest::TYPES.each do |name|
      self.points_of_interest.find_or_initialize_by :name => name
    end
  end

  def has_garage
    self.inside_parking_spots.to_i > 0 || self.inside_parking_spots_temporary.to_i > 0
  end

  def has_garage?
    has_garage
  end

  def has_parking_spot
    self.outside_parking_spots.to_i > 0 || self.outside_parking_spots_temporary.to_i > 0
  end

  def has_parking_spot?
    has_parking_spot
  end
end
