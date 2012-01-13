class GeoLocation
  include Mongoid::Document

  embedded_in :address
  
  field :lat, :type => String
  field :lng, :type => String
end
