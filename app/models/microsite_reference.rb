class MicrositeReference
  include Mongoid::Document
  embedded_in :microsite_reference, :polymorphic => true

  field :property_key, :type => String
  field :building_key, :type => String
end
