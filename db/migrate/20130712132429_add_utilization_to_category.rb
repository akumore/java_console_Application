class AddUtilizationToCategory < Mongoid::Migration
  def self.up
    # upate living sub-level categories
    [
      'flat',
      'attic_flat',
      'farm_house',
      'roof_flat',
      'bifamilar_house',
      'single_house',
      'single_room',
      'loft',
      'duplex',
      'multiple_dwelling',
      'furnished_flat',
      'row_house',
      'studio',
      'terrace_house',
      'terrace_flat',
      'villa'
    ].each_with_index do |sub_level, index|
      if sub_cat = Category.where(name: sub_level).first
        sub_cat.update_attributes(utilization: Utilization::LIVING, :utilization_sort_order => index + 1)
      end
    end

    # upate working sub-level categories
    [
      'office',
      'commercial',
      'agricultural_land',
      'atelier',
      'garage',
      'bakery',
      'building_land',
      'coffeehouse',
      'hairdresser',
      'factory',
      'department_store',
      'commercial_land',
      'hotel',
      'industrial_land',
      'industrial_object',
      'kiosk',
      'shop',
      'practice',
      'restaurant',
      'display_window',
      'advertising_area',
      'workshop',
      'living_commercial_building'
    ].each_with_index do |sub_level, index|
      if sub_cat = Category.where(:name => sub_level).first
        sub_cat.update_attributes(utilization: Utilization::WORKING, :utilization_sort_order => index + 1)
      end
    end

    # update working sub-level categories
    [
      'archives',
      'available',
      'hobby_room',
      'depot'
    ].each_with_index do |sub_level, index|
      if sub_cat = Category.where(:name => sub_level).first
        sub_cat.update_attributes(utilization: Utilization::STORING, :utilization_sort_order => index + 1)
      end
    end

    # parkink sub-level categories
    [
      'underground_slot',
      'open_slot',
      'covered_slot',
      'covered_parking_place_bike',
      'outdoor_parking_place_bike',
      'single_garage',
      'double_garage',
      'parking_surface',
      'parking_garage'
    ].each_with_index do |sub_level, index|
      if sub_cat = Category.where(:name => sub_level).first
        sub_cat.update_attributes(utilization: Utilization::PARKING, :utilization_sort_order => index + 1)
      end
    end

  end

  def self.down
    Category.excludes(parent_id: nil).each do |category|
      category.utilization = nil
      category.utilization_sort_order = nil
      category.save
    end
  end
end
