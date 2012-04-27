class MoveReferencesToAddress < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      real_estate.address.reference = real_estate.reference if real_estate.address.present?
      real_estate.unset :reference
      real_estate.save
    end
  end

  def self.down
    RealEstate.all.each do |real_estate|
      real_estate.reference = real_estate.address.reference if real_estate.address.present? && real_estate.address.reference.present?
      real_estate.address.unset :reference
      real_estate.save
    end
  end
end
