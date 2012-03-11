class AdditionalDescription

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :real_estate

  field :generic, :type => String
  field :location, :type => String
  field :interior, :type => String
  field :offer, :type => String
  field :infrastructure, :type => String
  field :usage, :type => String
  field :reference_date, :type => String
  field :orientation_degrees, :type => Integer
end
