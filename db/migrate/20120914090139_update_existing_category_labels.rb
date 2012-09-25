# encoding: utf-8

class UpdateExistingCategoryLabels < Mongoid::Migration
  # Just make sure we got the right locale
  I18n.locale = :de

  def self.up
    if Category.where(:label => 'Reihenfamilienhaus').first.present?
      Category.where(:label => 'Reihenfamilienhaus').first.update_attribute(:label, 'Reiheneinfamilienhaus')
    end

    if Category.where(:label => 'Ladenfläche').first.present?
      Category.where(:label => 'Ladenfläche').first.update_attribute(:label, 'Laden')
    end

    if Category.where(:label => 'offener Parkplatz').first.present?
      Category.where(:label => 'offener Parkplatz').first.update_attribute(:label, 'Parkplatz im Freien')
    end

    if Category.where(:label => 'Unterstand').first.present?
      Category.where(:label => 'Unterstand').first.update_attribute(:label, 'Parkplatz im Freien überdacht')
    end

    if Category.where(:label => 'Einzelgarage').first.present?
      Category.where(:label => 'Einzelgarage').first.update_attribute(:label, 'Parkplatz in Fertiggarage')
    end

    if Category.where(:label => 'Moto Hallenplatz').first.present?
      Category.where(:label => 'Moto Hallenplatz').first.update_attribute(:label, 'Motorrad-PP in Autoeinstellhalle')
    end

    if Category.where(:label => 'Moto Aussenplatz').first.present?
      Category.where(:label => 'Moto Aussenplatz').first.update_attribute(:label, 'Motorrad-PP im Freien überdacht')
    end

    if Category.where(:label => 'Tiefgarage').first.present?
      Category.where(:label => 'Tiefgarage').first.update_attribute(:label, 'Parkplatz in Autoeinstellhalle')
    end

    if Category.where(:label => 'Parkplatz in Fertiggarage').first.present?
      Category.where(:label => 'Parkplatz in Fertiggarage').first.update_attribute(:label, 'Einzelgarage')
    end

    if secondary = Category.where(:name => 'secondary').first
      {
        'available' =>  { :label_translations => { :de => 'Disponibel', :fr => 'Versatile',   :it => 'Versatile', :en => 'Versatile' }, :parent => secondary },
        'archives' =>   { :label_translations => { :de => 'Archiv',     :fr => 'Archives',    :it => 'Archivio',  :en => 'Archives' }, :parent => secondary }
      }
      .each do |key, value|
        category = Category.find_or_create_by(:name => key)
        category.update_attributes(value)
      end
    end
  end

  def self.down
  end
end
