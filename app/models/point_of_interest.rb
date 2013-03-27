class PointOfInterest
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(public_transport shopping kindergarden elementary_school high_school highway_access)
  PARKING_TYPES = %w(public_transport highway_access)

  embedded_in :infrastructure

  delegate :present?, :to => :distance

  field :name, :type => String
  field :distance, :type => String

  validates :distance, :numericality => true, :allow_blank => true

end
