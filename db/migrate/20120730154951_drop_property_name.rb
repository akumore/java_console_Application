class DropPropertyName < Mongoid::Migration
  extend ActionView::Helpers::TextHelper

  def self.up
    RealEstate.collection.update({}, {'$unset' => {:property_name => 1}}, :multi => true)
  end

  def self.down
  end
end

