class Reference
  include Mongoid::Document
  #embedded_in :real_estate # deprecated
  embedded_in :referenceable, :polymorphic => true

  validate :validates_uniqueness_of_key_composition

  field :property_key, :type => String
  field :building_key, :type => String
  field :unit_key, :type => String

  def validates_uniqueness_of_key_composition
    allowed_keys = [:property_key, :building_key, :unit_key]
    attr_hash = {}
    allowed_keys.each {|a| attr_hash[a] = self.send(a) }
    if self.class.exists_by_attributes? attr_hash
      errors.add(:property_key, 'Halligalli!')
      return false
    end
  end

  def self.exists_by_attributes?(attributes)
    attribs = {}
    attributes.each_pair{|k,v| attribs["address.reference.#{k}"] = v }
    RealEstate.exists?(conditions: attribs)
  end
end
