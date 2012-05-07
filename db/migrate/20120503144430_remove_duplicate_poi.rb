class RemoveDuplicatePoi < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.infrastructure.present?
        real_estate.infrastructure.points_of_interest.where(:distance => '').map(&:destroy)
        real_estate.infrastructure.points_of_interest.where(:distance => nil).map(&:destroy)


        PointOfInterest::TYPES.each do |type|
          if real_estate.infrastructure.points_of_interest.where(:name => type).length > 1
            real_estate.infrastructure.points_of_interest.where(:name => type).skip(1).map(&:destroy)
          end
        end

      end
    end
  end

  def self.down
  end
end
