class UpdateCategoryLabelsInRealEstates < Mongoid::Migration
  def self.up
    RealEstate.all.map { |x| x.save(:validate => false) }
  end

  def self.down
  end
end
