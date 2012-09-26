class UpdateCategoryLabelsInRealEstates < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.category.present?
        real_estate.category_label_translations = real_estate.category.label_translations
        real_estate.save(:validate => false)
      end
    end
  end

  def self.down
  end
end
