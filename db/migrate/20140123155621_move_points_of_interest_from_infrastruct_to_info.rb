class MovePointsOfInterestFromInfrastructToInfo < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "infrastructure.points_of_interest" => "information.points_of_interest"} }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "information.points_of_interest" => "infrastructure.points_of_interest"} }, :multi => true)
  end
end
