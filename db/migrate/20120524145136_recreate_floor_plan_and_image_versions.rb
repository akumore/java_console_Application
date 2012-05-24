class RecreateFloorPlanAndImageVersions < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      real_estate.floor_plans.each { |floor_plan| floor_plan.file.recreate_versions! if floor_plan.file.present? }
      real_estate.images.each { |image| image.file.recreate_versions! if image.file.present? }
    end
  end

  def self.down
  end
end
