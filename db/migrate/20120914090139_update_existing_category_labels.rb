# encoding: utf-8

class UpdateExistingCategoryLabels < Mongoid::Migration
  def self.up
    if Category.where(:label => 'Attikawohnung').first.present?
      Category.where(:label => 'Attikawohnung').first.update_attribute(:name, 'Attika-Wohnung')
    end

    if Category.where(:label => 'Dachwohnung').first.present?
      Category.where(:label => 'Dachwohnung').first.update_attribute(:name, 'Dach-Wohnung')
    end

    if Category.where(:label => 'Terrassenwohnung').first.present?
      Category.where(:label => 'Terrassenwohnung').first.update_attribute(:name, 'Terrassen-Wohnung')
    end

    if Category.where(:label => 'Reihenfamilienhaus').first.present?
      Category.where(:label => 'Reihenfamilienhaus').first.update_attribute(:name, 'Reihenfamilienhaus')
    end

    if Category.where(:label => 'Reihenfamilienhaus').first.present?
      Category.where(:label => 'Reihenfamilienhaus').first.update_attribute(:name, 'Reiheneinfamilienhaus')
    end

    if Category.where(:label => 'Ladenfläche').first.present?
      Category.where(:label => 'Ladenfläche').first.update_attribute(:name, 'Laden')
    end

    if Category.where(:label => 'offener Parkplatz').first.present?
      Category.where(:label => 'offener Parkplatz').first.update_attribute(:name, 'Parkplatz im Freien')
    end

    if Category.where(:label => 'Unterstand').first.present?
      Category.where(:label => 'Unterstand').first.update_attribute(:name, 'Parkplatz im Freien überdacht')
    end

    if Category.where(:label => 'Einzelgarage').first.present?
      Category.where(:label => 'Einzelgarage').first.update_attribute(:name, 'Parkplatz in Fertiggarage')
    end

    if Category.where(:label => 'Moto Hallenplatz').first.present?
      Category.where(:label => 'Moto Hallenplatz').first.update_attribute(:name, 'Motorrad-PP in Autoeinstellhalle')
    end

    if Category.where(:label => 'Moto Aussenplatz').first.present?
      Category.where(:label => 'Moto Aussenplatz').first.update_attribute(:name, 'Motorrad-PP im Freien überdacht')
    end
  end

  def self.down
  end
end
