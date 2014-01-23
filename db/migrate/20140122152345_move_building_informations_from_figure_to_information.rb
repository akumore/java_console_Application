class MoveBuildingInformationsFromFigureToInformation < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "figure.built_on" => "information.built_on",
                                                      "figure.renovated_on" => "information.renovated_on",
                                                      "figure.floors" => "information.floors",
                                                      "figure.ceiling_height" => "information.ceiling_height"
                                                    } }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "information.built_on" => "figure.built_on",
                                                      "information.renovated_on" => "figure.renovated_on",
                                                      "information.floors" => "figure.floors",
                                                      "information.ceiling_height" => "figure.ceiling_height"
                                                    } }, :multi => true)
  end
end
