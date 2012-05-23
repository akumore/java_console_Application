class ConvertFigureLivingSurfaceToNumber < Mongoid::Migration

  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.figure.present?
        real_estate.figure.living_surface = real_estate.figure.living_surface
        real_estate.figure.save(:validate => false)
      end
    end
  end

  def self.down
  end

end