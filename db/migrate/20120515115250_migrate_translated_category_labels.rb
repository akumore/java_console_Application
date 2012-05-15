class MigrateTranslatedCategoryLabels < Mongoid::Migration
  def self.up
    # categories are assigned in an after_validation callback
    RealEstate.all.map(&:save)
  end

  def self.down
  end
end
