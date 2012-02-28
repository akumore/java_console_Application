class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  CANTONS = %w(ag ar ai bl bs be fr ge gl gr ju lu ne nw ow sh sz so sg ti tg ur vd vs zg zh)

  embedded_in :real_estate
  embeds_one :geo_location

  field :city, :type => String
  field :street, :type => String
  field :street_number, :type => String
  field :zip, :type => String
  field :canton, :type => String
  field :link_url, :type => String

  validates :city, :presence => true
  validates :street, :presence => true
  validates :zip, :presence => true
  validates :canton, :presence => true, :inclusion => Address::CANTONS
end
