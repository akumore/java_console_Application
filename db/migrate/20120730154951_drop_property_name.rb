class DropPropertyName < Mongoid::Migration

  def self.up
    RealEstate.collection.update({}, {'$unset' => {:property_name => 1}}, :multi => true)
  end

  def self.down
  end

end

