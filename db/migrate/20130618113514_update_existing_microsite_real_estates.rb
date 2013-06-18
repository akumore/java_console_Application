class UpdateExistingMicrositeRealEstates < Mongoid::Migration
  def self.up
    RealEstate.microsite.each do |real_estate|
      real_estate.update_attribute(:microsite, Microsite::GARTENSTADT)
    end
  end

  def self.down
    RealEstate.microsite.each do |real_estate|
      real_estate.update_attribute(:microsite, '')
    end
  end
end
