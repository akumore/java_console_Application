class AddDefaultCreatorToRealEstates < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      real_estate.creator = real_estate.editor

      if real_estate.creator.blank?
        real_estate.creator = Cms::User.where(:email => 'admin@screenconcept.ch').first
      end

      real_estate.save(:validate => false)
    end
  end

  def self.down
    # do nothing
  end
end
