class RemoveDuplicatePoi < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.infrastructure.present?
        PointOfInterest::TYPES.each do |type|
          if real_estate.infrastructure.points_of_interest.where(:name => type).length > 1
            real_estate.infrastructure.points_of_interest.where(:name => type).skip(1).map(&:delete)
          end
        end
      end
    end
  end

  def self.down
  end
end
