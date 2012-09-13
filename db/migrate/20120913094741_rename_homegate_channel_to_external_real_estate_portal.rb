class RenameHomegateChannelToExternalRealEstatePortal < Mongoid::Migration
  def self.up
    RealEstate.collection.update({:channels => 'homegate'}, {'$push' => {:channels => 'external_real_estate_portal'}}, :multi => true)
    RealEstate.collection.update({:channels => 'homegate'}, {'$pull' => {:channels => 'homegate'}}, :multi => true)
  end

  def self.down
    RealEstate.collection.update({:channels => 'external_real_estate_portal'}, {'$push' => {:channels => 'homegate'}}, :multi => true)
    RealEstate.collection.update({:channels => 'external_real_estate_portal'}, {'$pull' => {:channels => 'external_real_estate_portal'}}, :multi => true)
  end
end
