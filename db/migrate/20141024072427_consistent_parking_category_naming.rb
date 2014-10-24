class ConsistentParkingCategoryNaming < Mongoid::Migration
  RENAMES = {
    'open_slot' => 'outside_parking',
    'underground_slot' => 'inside_parking',
    'covered_parking_place_bike' => 'covered_bike',
    'outdoor_parking_place_bike' => 'outdoor_bike'
  }
  def self.up
    RENAMES.each do |from_name, to_name|
      cat = Category.where(name: from_name).first
      cat.name = to_name
      cat.save
    end
  end

  def self.down
    RENAMES.invert.each do |from_name, to_name|
      cat = Category.where(name: from_name).first
      cat.name = to_name
      cat.save
    end
  end
end
