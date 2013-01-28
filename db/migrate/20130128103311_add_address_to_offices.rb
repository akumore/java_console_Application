# encoding: utf-8
class AddAddressToOffices < Mongoid::Migration
  def self.up
    if baar = Office.where(:name => 'baar').first
      baar.update_attributes(
        :company_label => 'Alfred Müller AG',
        :street => 'Neuhofstrasse 10',
        :zip => '6340',
        :city => 'Baar',
        :phone => '+41 41 767 02 02',
        :fax => '+41 41 767 02 00'
      )
    end

    if marin = Office.where(:name => 'marin').first
      marin.update_attributes(
        :company_label => 'Alfred Müller SA',
        :street => 'Av. des Champs-Montants 10a',
        :zip => '2074',
        :city => 'Marin',
        :phone => '+41 32 756 92 92',
        :fax => '+41 32 756 92 99'
      )
    end

    if camorino = Office.where(:name => 'camorino').first
      camorino.update_attributes(
        :company_label => 'Alfred Müller SA',
        :street => 'Centro Monda 3',
        :zip => '6568',
        :city => 'Camorino',
        :phone => '+41 91 858 25 94',
        :fax => '+41 91 858 25 54'
      )
    end
  end

  def self.down
    # useless
  end
end
