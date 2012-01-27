class Information
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :available_from, :type => Date
  field :display_estimated_available_from, :type=>String
  field :has_outlook, :type=>Boolean
  field :has_fireplace, :type=>Boolean
  field :has_elevator, :type=>Boolean
  field :has_isdn, :type=>Boolean
  field :is_wheelchair_accessible, :type=>Boolean
  field :is_child_friendly, :type=>Boolean
  field :has_balcony, :type=>Boolean
  field :has_raised_ground_floor, :type=>Boolean
  field :is_new_building, :type=>Boolean
  field :is_old_building, :type=>Boolean
  field :has_swimming_pool, :type=>Boolean
  field :is_minergie_style, :type=>Boolean
  field :is_minergie_certified, :type=>Boolean
  field :maximal_floor_loading, :type=>Integer
  field :freight_elevator_carrying_capacity, :type=>Integer
  field :has_ramp, :type=>Boolean
  field :has_lifting_platform, :type=>Boolean
  field :has_railway_terminal, :type=>Boolean
  field :number_of_restrooms, :type=>Integer
  field :has_water_supply, :type=>Boolean
  field :has_sewage_supply, :type=>Boolean
  field :is_developed, :type=>Boolean
  field :is_under_building_laws, :type=>Boolean

  validates_size_of :maximal_floor_loading, :freight_elevator_carrying_capacity, :number_of_restrooms, :minimum=>0, :allow_blank=>true

end
