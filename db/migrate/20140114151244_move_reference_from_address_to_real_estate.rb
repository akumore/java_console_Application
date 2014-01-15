class MoveReferenceFromAddressToRealEstate < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.export_to_real_estate_portal? && real_estate.address.present?
        reference = real_estate.address.reference
      else
        reference = Reference.new
      end
      real_estate.update_attribute(:reference, reference)
    end
  end

  def self.down
    RealEstate.all.each do |real_estate|
      real_estate.update_attribute(:reference, nil)
    end
  end
end
