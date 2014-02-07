class AdditionalDescription

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :orientation_degrees, :type => Integer
end
