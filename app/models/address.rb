class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  include Geocoder::Model::Mongoid
  geocoded_by :address, :coordinates => :location

  CANTONS = %w(ag ar ai bl bs be fr ge gl gr ju lu ne nw ow sh sz so sg ti tg ur vd vs zg zh)

  embedded_in :real_estate

  field :city, :type => String
  field :street, :type => String
  field :street_number, :type => String
  field :zip, :type => String
  field :canton, :type => String
  field :country, :type => String, :defaults => "Schweiz"
  field :link_url, :type => String

  validates :city, :presence => true
  validates :street, :presence => true
  validates :zip, :presence => true
  validates :canton, :presence => true, :inclusion => Address::CANTONS

  field :location, :type => Array #Keep in mind coordinates are stored in long, lat order internally!! Use to_coordinates always.
  #index [[ :location, Mongo::GEO2D ]] TODO Do we need this?


  after_validation :geocode, :if => :address_changed?
  attr_protected :location

  def address
    [[street, street_number].compact.join(' '), zip, city, canton, country].compact.join(', ')
  end

  def address_changed?
    [:street, :street_number, :zip, :city, :canton, :country].inject(false) do |res, attr|
      res || changed.include?(attr.to_s)
    end
  end
end
