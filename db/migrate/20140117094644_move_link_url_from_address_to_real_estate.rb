class MoveLinkUrlFromAddressToRealEstate < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "address.link_url" => "link_url"} }, :multi => true)  
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "link_url" => "address.link_url"} }, :multi => true)
  end
end
