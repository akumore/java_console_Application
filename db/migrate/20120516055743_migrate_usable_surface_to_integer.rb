class MigrateUsableSurfaceToInteger < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      usable_surface = real_estate.try(:figure).try(:usable_surface)

      if usable_surface.present?

        value = if usable_surface.to_s.include?('.')
          Float(usable_surface)
        else
          Integer(usable_surface)
        end

        unless value.nil?
          real_estate.figure.update_attribute :usable_surface, value
        end

      end

    end
  end

  def self.down
  end
end
