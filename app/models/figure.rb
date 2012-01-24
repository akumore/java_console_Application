class Figure
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :floor, :type => Integer
  field :floor_estimate, :type => String # 1-5 Stock
  field :rooms, :type => String # 
  field :rooms_estimate, :type => String # 3-5 Zimmer
  field :living_surface, :type => String
  field :living_surface_estimate, :type => String # 50-80 Quadratmeter
  field :property_surface, :type => String # Grundstückfläche
  field :usable_surface, :type => String # Nutzfläche
  field :storage_surface, :type => String # Lagerfläche
  field :ceiling_height, :type => String # Raumhöhe
  field :floors, :type => Integer # Anzahl Stockwerke
  field :renovated_on, :type => Integer # Renovationsjahr
  field :built_on, :type => Integer # Baujahr
end
