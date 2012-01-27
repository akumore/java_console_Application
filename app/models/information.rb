class Information
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :available_from, :type => Date
  field :display_estimated_available_from, :type=>String
  field :has_outlook, :type=>Boolean
  field :has_fireplace, :type=>Boolean #Cheminée
  field :has_elevator, :type=>Boolean #Lift
  field :has_isdn, :type=>Boolean
  field :is_wheelchair_accessible, :type=>Boolean #Barrierefrei
  field :is_child_friendly, :type=>Boolean
  field :has_balcony, :type=>Boolean
  field :has_raised_ground_floor, :type=>Boolean #Hochparterre
  field :is_new_building, :type=>Boolean #Neubau
  field :is_old_building, :type=>Boolean #Altbau
  field :has_swimming_pool, :type=>Boolean #Swimmingpool
  field :is_minergie_style, :type=>Boolean #Minergie Bauweise
  field :is_minergie_certified, :type=>Boolean #Minergie zertifiziert
  field :maximal_floor_loading, :type=>Integer #Maximale Bodenbelastung in KG
  field :freight_elevator_carrying_capacity, :type=>Integer #carrying_capacity_elevator	Max Gewicht Warenlift
  field :has_ramp, :type=>Boolean #Anfahrrampe
  field :has_lifting_platform, :type=>Boolean #Hebebühne
  field :has_railway_terminal, :type=>Boolean #Bahnanschluss
  field :number_of_restrooms, :type=>Integer  #TODO BATH ROOMS?
  field :has_water_supply, :type=>Boolean #Wasseranschluss
  field :has_sewage_supply, :type=>Boolean #Abwasseranschluss
  field :is_developed, :type=>Boolean #Bauland erschlossen
  field :is_under_building_laws, :type=>Boolean #im Baurecht

end
