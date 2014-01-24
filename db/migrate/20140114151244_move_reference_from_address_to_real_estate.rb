class MoveReferenceFromAddressToRealEstate < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "address.reference" => "reference"} }, :multi => true)  
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "reference" => "address.reference" } }, :multi => true)
  end
end
