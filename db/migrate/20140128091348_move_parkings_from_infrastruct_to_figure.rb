class MoveParkingsFromInfrastructToFigure < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "infrastructure.inside_parking_spots" => "figure.inside_parking_spots",
                                                      "infrastructure.outside_parking_spots" => "figure.outside_parking_spots",
                                                      "infrastructure.covered_slot" => "figure.covered_slot",
                                                      "infrastructure.covered_bike" => "figure.covered_bike",
                                                      "infrastructure.outdoor_bike" => "figure.outdoor_bike",
                                                      "infrastructure.single_garage" => "figure.single_garage",
                                                      "infrastructure.double_garage" => "figure.double_garage" } }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "figure.inside_parking_spots" => "infrastructure.inside_parking_spots",
                                                      "figure.outside_parking_spots" => "infrastructure.outside_parking_spots",
                                                      "figure.covered_slot" => "infrastructure.covered_slot",
                                                      "figure.covered_bike" => "infrastructure.covered_bike",
                                                      "figure.outdoor_bike" => "infrastructure.outdoor_bike",
                                                      "figure.single_garage" => "infrastructure.single_garage",
                                                      "figure.double_garage" => "infrastructure.double_garage" } }, :multi => true)
  end
end
