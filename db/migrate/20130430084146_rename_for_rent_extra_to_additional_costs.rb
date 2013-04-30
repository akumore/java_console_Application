class RenameForRentExtraToAdditionalCosts < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "pricing.for_rent_extra" => "pricing.additional_costs" } }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "pricing.additional_costs" => "pricing.for_rent_extra" } }, :multi => true)
  end
end
