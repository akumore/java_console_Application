class UpdateExistingMicrositeRealEstates < Mongoid::Migration
  def self.up
    RealEstate.microsite.each do |real_estate|
      real_estate.update_attribute(
        :microsite_building_project, MicrositeBuildingProject::GARTENSTADT
      )
    end
  end

  def self.down
    RealEstate.microsite.each do |real_estate|
      real_estate.update_attribute(:microsite_building_project, '')
    end
  end
end
