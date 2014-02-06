class MoveAdditionalInformation < Mongoid::Migration
  def self.up
    RealEstate.collection.update({}, { '$rename' => { "additional_description.location" => "information.location_html"} }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "additional_description.interior" => "information.interior_html"} }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "additional_description.infrastructure" => "information.infrastructure_html"} }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "additional_description.offer" => "figure.offer_html"} }, :multi => true)
  end

  def self.down
    RealEstate.collection.update({}, { '$rename' => { "information.location_html" => "additional_description.location" } }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "information.interior_html" => "additional_description.interior" } }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "information.infrastructure_html" => "additional_description.infrastructure" } }, :multi => true)
    RealEstate.collection.update({}, { '$rename' => { "figure.offer_html" => "additional_description.offer" } }, :multi => true)
  end
end
