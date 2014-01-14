class Reference
  include Mongoid::Document
  embedded_in :referenceable, :polymorphic => true

  field :property_key, :type => String
  field :building_key, :type => String
  field :unit_key, :type => String
end
