class MigrateGartenstadtMicrositeAttributes < Mongoid::Migration

  GARTENSTADT_STREET = 'Badenerstrasse'
  STREET_NUMBER_HOUSE_MAP = {
    '26' => 'M',
    '28' => 'L',
    '30' => 'K',
    '32' => 'I',
    '34' => 'H',
  }

  def self.up
    RealEstate.microsite.each do |real_estate|
      address = real_estate.address ||= Address.new
      address.microsite_reference ||= MicrositeReference.new

      if address.street.try(:strip) == GARTENSTADT_STREET then
        address.microsite_reference.building_key = STREET_NUMBER_HOUSE_MAP[address.street_number]
        real_estate.save!
      end
    end
  end
end
