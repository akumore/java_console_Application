class Infrastructure
  
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate
  embeds_many :points_of_interest, :class_name => 'PointOfInterest'

  accepts_nested_attributes_for :points_of_interest, :reject_if => :empty_point_of_interest

  field :has_parking_spot, :type => Boolean
  field :has_roofed_parking_spot, :type => Boolean
  field :has_garage, :type => Boolean
  field :inside_parking_spots, :type => Integer
  field :outside_parking_spots, :type => Integer
  field :inside_parking_spots_temporary, :type => Integer
  field :outside_parking_spots_temporary, :type => Integer

  def build_all_points_of_interest
    PointOfInterest::TYPES.each do |name|
      self.points_of_interest.find_or_initialize_by :name => name
    end
  end

  private

  def empty_point_of_interest poi
    poi[:distance].blank?
  end
end