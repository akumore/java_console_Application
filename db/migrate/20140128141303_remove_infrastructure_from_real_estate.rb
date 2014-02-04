class RemoveInfrastructureFromRealEstate < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$unset' => {:infrastructure => 1} }, :multi => true)
  end

  def self.down
  end
end
