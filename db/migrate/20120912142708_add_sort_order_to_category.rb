class AddSortOrderToCategory < Mongoid::Migration
  def self.up
    Category.top_level.each do |category|
      if category.name == 'apartment'
        category.sort_order = 1
      elsif category.name == 'house'
        category.sort_order = 2
      elsif category.name == 'industrial'
        category.sort_order = 3
      elsif category.name == 'parking'
        category.sort_order = 4
      elsif category.name == 'secondary'
        category.sort_order = 5
      elsif category.name == 'properties'
        category.sort_order = 6
      elsif category.name == 'gastronomy'
        category.sort_order = 7
      end

      category.save
    end
  end

  def self.down
    Category.top_level.each do |category|
      category.sort_order = nil
      category.save
    end
  end
end
