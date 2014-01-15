class MoveReferenceFromAddressToRealEstate < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.export_to_real_estate_portal? && real_estate.address.present?
        reference = real_estate.address.reference
      else
        reference = Reference.new
      end
      real_estate.reference = reference
      real_estate.save(validate: false)
    end
  end

  def self.down
    RealEstate.all.each do |real_estate|
      real_estate.reference = nil
      real_estate.save(validate: false)
    end
  end
end
