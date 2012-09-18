# encoding: utf-8

class UpdateExistingCategoryLabels < Mongoid::Migration
  def self.up
    if Category.where(:label => 'Attikawohnung').first.present?
      Category.where(:label => 'Attikawohnung').first.update_attribute(:label, 'Attika-Wohnung')
    end

    if Category.where(:label => 'Dachwohnung').first.present?
      Category.where(:label => 'Dachwohnung').first.update_attribute(:label, 'Dach-Wohnung')
    end

    if Category.where(:label => 'Terrassenwohnung').first.present?
      Category.where(:label => 'Terrassenwohnung').first.update_attribute(:label, 'Terrassen-Wohnung')
    end

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
  end

  def self.down
  end
end
