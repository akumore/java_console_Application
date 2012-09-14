class AddDefaultCreatorToRealEstates < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      real_estate.creator = real_estate.editor
      real_estate.save(:validate => false)
    end
  end

  def self.down
    # do nothing
  end
end
