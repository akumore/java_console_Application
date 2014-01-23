class Information
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  embedded_in :real_estate

  field :has_outlook, :type => Boolean
  field :has_fireplace, :type => Boolean
  field :has_elevator, :type => Boolean
  field :has_isdn, :type => Boolean
  field :is_wheelchair_accessible, :type => Boolean
  field :is_child_friendly, :type => Boolean
  field :has_balcony, :type => Boolean
  field :has_garden_seating, :type => Boolean
  field :has_raised_ground_floor, :type => Boolean
  field :is_new_building, :type => Boolean
  field :is_old_building, :type => Boolean
  field :has_swimming_pool, :type => Boolean
  field :is_minergie_style, :type => Boolean
  field :is_minergie_certified, :type => Boolean
  field :maximal_floor_loading, :type => Integer
  field :freight_elevator_carrying_capacity, :type => Integer
  field :has_ramp, :type => Boolean
  field :has_lifting_platform, :type => Boolean
  field :has_railway_terminal, :type => Boolean
  field :number_of_restrooms, :type => Integer
  field :has_water_supply, :type => Boolean
  field :has_sewage_supply, :type => Boolean
  field :is_developed, :type => Boolean
  field :is_under_building_laws, :type => Boolean
  field :has_cable_tv, :type => Boolean
  field :additional_information, :type => String
  field :built_on, :type => Integer # Baujahr
  field :renovated_on, :type => Integer # Renovationsjahr
  field :floors, :type => Integer # Anzahl Stockwerke
  field :ceiling_height, :type => String # Raumhöhe

  validates_numericality_of :freight_elevator_carrying_capacity,
                            :number_of_restrooms,
                            :maximal_floor_loading,
                            :built_on,
                            :renovated_on,
                            :floors,
                            :greater_than_or_equal_to => 0,
                            :allow_nil => true

  # ceiling_height must be numeric, but only if commercial
  validates :ceiling_height,
            :numericality => true,
            :allow_blank => true,
            :if => :working?

  delegate :living?, :working?, :storing?, :parking?, :to => :_parent

  def has_freight_elevator?
    freight_elevator_carrying_capacity > 0 if freight_elevator_carrying_capacity.present?
  end
end
