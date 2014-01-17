class MoveMicrositeReferenceFromAddressToRealEstate < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "address.microsite_reference" => "microsite_reference"} }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "microsite_reference" => "address.microsite_reference"} }, :multi => true)
  end
end
