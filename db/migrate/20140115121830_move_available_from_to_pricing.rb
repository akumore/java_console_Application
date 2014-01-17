class MoveAvailableFromToPricing < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "information.available_from" => "pricing.available_from" } }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "information.display_estimated_available_from" => "pricing.display_estimated_available_from" } }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "pricing.available_from" => "information.available_from" } }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "pricing.display_estimated_available_from" => "information.display_estimated_available_from" } }, :multi => true)
  end
end
