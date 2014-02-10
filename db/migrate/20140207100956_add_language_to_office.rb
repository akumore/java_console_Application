class AddLanguageToOffice < Mongoid::Migration

  def self.up
    Office.all.each {|office|
      case office.name
      when 'camorino'
        office.language = 'it'
      when 'marin'
        office.language = 'fr'
      else
        office.language = 'de'
      end
      office.save!
    }
  end

  def self.down
    Office.all.each {|office|
      office.language.unset
      office.save!
    }
  end
end
