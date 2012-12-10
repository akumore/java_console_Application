class AssignOfficeToRealEstates < Mongoid::Migration
  def self.up
    office = Office.where(:name => 'baar').first

    if office.present?
      RealEstate.all.each do |real_estate|
        real_estate.update_attribute :office_id, office.id
      end
    end
  end

  def self.down
  end
end
