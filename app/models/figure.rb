class Figure
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :floor, :type => Integer
  field :floor_estimate, :type => String # 1-5 Stock
  field :rooms, :type => String #
  field :rooms_estimate, :type => String # 3-5 Zimmer
  field :living_surface, :type => Integer
  field :living_surface_estimate, :type => String # 50-80 Quadratmeter
  field :property_surface, :type => String # Grundstückfläche
  field :property_surface_estimate, :type => String # Grundstückfläche ungefähr
  field :usable_surface, :type => Integer # Nutzfläche
  field :usable_surface_estimate, :type => String # Nutzfläche ungefähr
  field :storage_surface, :type => String # Lagerfläche
  field :ceiling_height, :type => String # Raumhöhe
  field :floors, :type => Integer # Anzahl Stockwerke
  field :renovated_on, :type => Integer # Renovationsjahr
  field :built_on, :type => Integer # Baujahr

  # fields which must be numeric
  validates :property_surface, :floors, :floor, :renovated_on, :built_on,
            :numericality => true,
            :allow_blank => true

  # fields which must be numeric, but only if private
  validates :living_surface,
            :numericality => true,
            :allow_blank => true,
            :if => :private_utilization?

  # fields which must be numeric, but only if commercial
  validates :ceiling_height, :storage_surface,
            :numericality => true,
            :allow_blank => true,
            :if => :commercial_utilization?

  # fields which must be present and numeric, but only if private
  validates :rooms,
            :presence => true,
            :numericality => true,
            :if => :private_utilization?

  # fields which must be present and numeric, but only if commercial
  validates :usable_surface,
            :presence => true,
            :numericality => true,
            :if => :commercial_utilization?

  validates :floor,
            :presence => true,
            :numericality => true

  delegate :commercial_utilization?, :private_utilization?, :to => :_parent
end
