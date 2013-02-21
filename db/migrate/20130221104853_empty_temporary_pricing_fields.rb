class EmptyTemporaryPricingFields < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.pricing.present?
        real_estate.pricing.inside_parking_temporary = nil
        real_estate.pricing.outside_parking_temporary = nil
        real_estate.save
      end
    end
  end

  def self.down
  end
end
