class AdditionalDescription

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :offer, :type => String
  field :orientation_degrees, :type => Integer
end
