class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  include Geocoder::Model::Mongoid
  geocoded_by :address, :coordinates => :location

  CANTONS = %w(ag ar ai bl bs be fr ge gl gr ju lu ne nw ow sh sz so sg ti tg ur vd vs zg zh)

  embedded_in :real_estate
  embeds_one :reference, :as => :referencable
  embeds_one :microsite_reference

  field :city, :type => String
  field :street, :type => String
  field :street_number, :type => String
  field :zip, :type => String
  field :canton, :type => String
  field :country, :type => String, :defaults => "Schweiz"
  field :link_url, :type => String
  field :manual_geocoding, :type => Boolean

  validates :city, :presence => true
  validates :street, :presence => true
  validates :zip, :presence => true
  validates :canton, :presence => true, :inclusion => CANTONS
  validates :any_reference_key, :presence => true, :if => :export_to_real_estate_portal?
  validate :validates_uniqueness_of_key_composition, :if => :export_to_real_estate_portal?
  validates :lat, :lng, :presence => true, :if => :manual_geocoding?

  field :location, :type => Array #Keep in mind coordinates are stored in long, lat order internally!! Use to_coordinates always.

  attr_writer :lat
  attr_writer :lng

  after_validation :geocode, :if => :should_geocode?
  before_validation :manually_geocode, :if => :manual_geocoding?
  after_initialize :init_reference
  after_initialize :init_microsite_reference
  attr_protected :location

  alias :coordinates :to_coordinates
  delegate :export_to_real_estate_portal?, :to => :_parent

  def address
    [[street, street_number].compact.join(' '), zip, city, canton, country].compact.join(', ')
  end

  def address_changed?
    [:street, :street_number, :zip, :city, :canton, :country, :manual_geocoding].inject(false) do |res, attr|
      res || changed.include?(attr.to_s)
    end
  end

  def should_geocode?
    address_changed? && manual_geocoding? == false
  end

  def manually_geocode
    self.location = [@lng, @lat] if @lat.presence && @lng.presence
  end

  def lat
    location.last if location.present?
  end

  def lng
    location.first if location.present?
  end

  private

  def init_reference
    self.reference ||= Reference.new
  end

  def init_microsite_reference
    self.microsite_reference ||= MicrositeReference.new
  end

  def any_reference_key
    (reference.property_key.presence || reference.building_key.presence || reference.unit_key.presence) if reference.present?
  end

  def validates_uniqueness_of_key_composition
    allowed_keys = [:property_key, :building_key, :unit_key]
    attr_hash = {}
    allowed_keys.each { |a| attr_hash[a] = self.reference.send(a) }

    if self.class.exists_by_attributes? attr_hash
      errors.add(:reference_key_combination, 'Halligalli!')
    end
  end

  def self.exists_by_attributes?(attributes)
    attribs = {}
    attributes.each_pair{|k,v| attribs["address.reference.#{k}"] = v }
    RealEstate.exists?(conditions: attribs)
  end
end
