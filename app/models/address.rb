class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  include Geocoder::Model::Mongoid
  geocoded_by :address, :coordinates => :location

  CANTONS = %w(ag ar ai bl bs be fr ge gl gr ju lu ne nw ow sh sz so sg ti tg ur vd vs zg zh)

  embedded_in :real_estate
  embeds_one :reference, :as => :referencable

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
  validates :any_reference_key, :presence => true, :if => :is_homegate?

  field :location, :type => Array #Keep in mind coordinates are stored in long, lat order internally!! Use to_coordinates always.
  #index [[ :location, Mongo::GEO2D ]] TODO Do we need this?

  after_validation :geocode, :if => :address_changed?
  after_initialize :init_reference
  attr_protected :location

  alias :coordinates :to_coordinates
  delegate :is_homegate?, :to => :_parent

  def address
    [[street, street_number].compact.join(' '), zip, city, canton, country].compact.join(', ')
  end

  def address_changed?
    [:street, :street_number, :zip, :city, :canton, :country].inject(false) do |res, attr|
      res || changed.include?(attr.to_s)
    end
  end

  private

  def init_reference
    self.reference ||= Reference.new
  end

  def any_reference_key
    (reference.property_key.presence || reference.building_key.presence || reference.unit_key.presence) if reference.present?
  end
end
