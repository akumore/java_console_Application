class MoveBuildingInformationsFromFigureToInformation < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "figure.built_on" => "information.built_on",
                                                      "figure.renovated_on" => "information.renovated_on",
                                                      "figure.floors" => "information.floors"
                                                    } }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "information.built_on" => "figure.built_on",
                                                      "information.renovated_on" => "figure.renovated_on",
                                                      "information.floors" => "figure.floors"
                                                    } }, :multi => true)
  end
end
