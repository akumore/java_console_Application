class RecreateFloorPlanImageVersions < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      real_estate.floor_plans.each { |floor_plan| floor_plan.file.recreate_versions! }
    end
  end

  def self.down
  end
end