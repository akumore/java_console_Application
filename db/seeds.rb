# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Cms::User.create(email: 'admin@screenconcept.ch', password: 'bambus', password_confirmation: 'bambus')
Cms::User.create(email: 'staging@alfred-mueller.ch', password: 'am2012', password_confirmation: 'am2012')

module InitialCategories

  # Top level categories

  {
      'apartment' => {:label => 'Wohnung'},
      'gastronomy' => {:label => 'Gastronomie'},
      'house' => {:label => 'Haus'},
      'industrial' => {:label => 'Gewerbe/Industrie'},
      'parking' => {:label => 'Parkplatz'},
      'properties' => {:label => 'Grundstück'},
      'secondary' => {:label => 'Wohnnebenräume'}
  }.each do |key, value|
    category = Category.find_or_create_by(:name => key)
    category.update_attributes(value)
  end

  # Sub level categories

  def self.create_sublevel_for(top_level_name, sublevel_category)
    top_level = Category.where(:name => top_level_name).first
    category = Category.find_or_create_by(:name => sublevel_category[:name])
    category.update_attributes(sublevel_category.merge(:parent => top_level))
  end

  [{
       :label => 'Wohnung',
       :name => 'flat'
   },
   {
       :label => 'Maisonette',
       :name => 'duplex'
   },
   {
       :label => 'Attikawohnung',
       :name => 'attic_flat'
   },
   {
       :label => 'Dachwohnung',
       :name => 'roof_flat'
   },
   {
       :label => 'Studio',
       :name => 'studio'
   },
   {
       :label => 'Einzelzimmer',
       :name => 'single_room'
   },
   {
       :label => 'Möbl. Wohnobj.',
       :name => 'furnished_flat'
   },
   {
       :label => 'Terrassenwohnung',
       :name => 'terrace_flat'
   },
   {
       :label => 'Loft',
       :name => 'loft'
   }
  ].each do |sublevel_category|
    create_sublevel_for('apartment', sublevel_category)
  end

  [{
       :label => 'Hotel',
       :name => 'hotel'
   },
   {
       :label => 'Restaurant',
       :name => 'restaurant'
   },
   {
       :label => 'Café',
       :name => 'coffeehouse'
   }
  ].each do |sublevel_category|
    create_sublevel_for('gastronomy', sublevel_category)
  end

  [{
       :label => 'Einfamilienhaus',
       :name => 'single_house'
   },
   {
       :label => 'Reihenfamilienhaus',
       :name => 'row_house'
   },
   {
       :label => 'Doppeleinfamilienhaus',
       :name => 'bifamilar_house'
   },
   {
       :label => 'Terrassenhaus',
       :name => 'terrace_house'
   },
   {
       :label => 'Villa',
       :name => 'villa'
   },
   {
       :label => 'Bauernhaus',
       :name => 'farm_house'
   },
   {
       :label => 'Mehrfamilienhaus',
       :name => 'multiple_dwelling'
   }
  ].each do |sublevel_category|
    create_sublevel_for('house', sublevel_category)
  end

  [{
       :label => 'Büro',
       :name => 'office'
   },
   {
       :label => 'Ladenfläche',
       :name => 'shop'
   },
   {
       :label => 'Werbefläche',
       :name => 'advertising_area'
   },
   {
       :label => 'Gewerbe',
       :name => 'commercial'
   },
   {
       :label => 'Praxis',
       :name => 'practice'
   },
   {
       :label => 'Kiosk',
       :name => 'kiosk'
   },
   {
       :label => 'Autogarage',
       :name => 'garage'
   },
   {
       :label => 'Bäckerei',
       :name => 'bakery'
   },
   {
       :label => 'Coiffeursalon',
       :name => 'hairdresser'
   },
   {
       :label => 'Fabrik',
       :name => 'factory'
   },
   {
       :label => 'Industrieobjekt',
       :name => 'industrial_object'
   },
   {
       :label => 'Atelier',
       :name => 'aterlier'
   },
   {
       :label => 'Wohn- / Geschäftshaus',
       :name => 'living_commercial_building'
   },
   {
       :label => 'Werkstatt',
       :name => 'workshop'
   },
   {
       :label => 'Geschäftshaus',
       :name => 'department_store'
   },
   {
       :label => 'Schaufenster',
       :name => 'display_window'
   },
   {
       :label => 'Parkhaus',
       :name => 'parking_garage'
   },
   {
       :label => 'Parkfläche',
       :name => 'parking_surface'
   }
  ].each do |sublevel_category|
    create_sublevel_for('industrial', sublevel_category)
  end

  [{
       :label => 'Offener Parkplatz',
       :name => 'open_slot'
   },
   {
       :label => 'Unterstand',
       :name => 'covered_slot'
   },
   {
       :label => 'Einzelgarage',
       :name => 'single_garage'
   },
   {
       :label => 'Doppelgarage',
       :name => 'double_garage'
   },
   {
       :label => 'Tiefgarage',
       :name => 'underground_slot'
   },
   {
       :label => 'Moto Hallenplatz',
       :name => 'covered_parking_place_bike'
   },
   {
       :label => 'Moto Aussenplatz',
       :name => 'outdoor_parking_place_bike'
   }
  ].each do |sublevel_category|
    create_sublevel_for('parking', sublevel_category)
  end

  [{
       :label => 'Bauland',
       :name => 'building_land'
   },
   {
       :label => 'Agrarland',
       :name => 'agricultural_land'
   },
   {
       :label => 'Gewerbeland',
       :name => 'commercial_land'
   },
   {
       :label => 'Industriebauland',
       :name => 'industrial_land'
   }
  ].each do |sublevel_category|
    create_sublevel_for('properties', sublevel_category)
  end

  [{
       :label => 'Hobbyraum',
       :name => 'hobby_room'
   }
  ].each do |sublevel_category|
    create_sublevel_for('secondary', sublevel_category)
  end

  if Rails.env.development? || Rails.env.staging?
    module Examples
      module InitSomeRealEstates
        gartenstadt_images = Dir.glob("#{Rails.root}/db/seeds/real_estates/Gartenstadt-Schlieren/*.png")
        #lorenzhof_images = Dir.glob("#{Rails.root}/db/seeds/real_estates/Lorenzhof-Cham/*.png")

        r = RealEstate.find_or_create_by(:title=>'SC Sample Object 1')
        r.state = RealEstate::STATE_EDITING
        r.utilization = RealEstate::UTILIZATION_PRIVATE
        r.offer = RealEstate::OFFER_FOR_RENT
        r.channels = [RealEstate::CHANNELS.first]
        r.reference = Reference.new(
            :property_key=>'SC P 1', :building_key=>'SC B 1', :unit_key=>'SC U 1'
        )
        r.address = Address.new(:canton=>'AG',
                                :city=>'Fahrwangen', :street=>'Bahnhofstrasse', :street_number=>'18'
        )
        r.category = Category.where(:name=>'flat').first
        r.pricing = Pricing.new(:price_unit=>Pricing::PRICE_UNITS.first, :for_rent_netto=>2380, :for_rent_extra=>380)
        r.figure = Figure.new(:floor=>3, :living_surface=>186)
        r.information = Information.new(:available_from=>Date.parse('2012-01-21'))
        r.infrastructure = Infrastructure.new(:has_parking_spot=>true)
        r.description = "Beschreibung 1!!!"
        r.descriptions = Description.new(:generic=>'Die Wohnung ist mit Keramikbodenplatten belegt und...')
        r.media_assets = gartenstadt_images.map { |img_path|
          MediaAsset.new(
              :media_type=>MediaAsset::IMAGE,
              :is_primary=>img_path==gartenstadt_images.first,
              :file=>File.open(img_path),
              :title=>"IMG #{File.basename(img_path)}"
          )
        }
        r.save!

        4.times do |t|
          r = RealEstate.find_or_create_by(:title=>"Sample Object #{t}")
          r.state = RealEstate::STATE_EDITING
          r.utilization = RealEstate::UTILIZATION_PRIVATE
          r.offer = RealEstate::OFFER_FOR_RENT
          r.channels = [RealEstate::CHANNELS.first]
          r.reference = Reference.new(
              :property_key=>"P #{t}", :building_key=>"B #{t}", :unit_key=>"U #{t}"
          )
          r.address = Address.new(:canton=>'AG',
                                  :city=>'Fahrwangen', :street=>'Bahnhofstrasse', :street_number=>'18'
          )
          r.information = Information.new(:available_from=>Date.parse('2012-01-01'))
          r.category = Category.where(:name=>'flat').first
          r.pricing = Pricing.new(:price_unit=>Pricing::PRICE_UNITS.first, :for_rent_netto=>2380, :for_rent_extra=>380)
          r.figure = Figure.new(:floor=>3, :living_surface=>186)
          r.infrastructure = Infrastructure.new(:has_parking_spot=>true)
          r.description = "Beschreibung 1"
          r.descriptions = Description.new(:generic=>'Die Wohnung ist mit Keramikbodenplatten belegt und...')
          r.save!
        end

      end
    end
  end

module InitialPages

  # Jobs Page

  jobs_page = Page.create(:title => 'Jobs', :name => 'jobs')
  jobs_page.bricks << Brick::Title.new(:title => 'Der Mensch steht bei uns im Mittelpunkt')
  jobs_page.bricks << Brick::Text.new(:text => 'Den grössten Teil unseres Lebens verbringen wir in Immobilien – sei es zuhause oder am Arbeitsplatz. Deshalb haben wir es uns zur Aufgabe gemacht, hochwertige Wohn- und Geschäftshäuser zu entwickeln, in denen sich die Menschen wohl fühlen. Wollen Sie uns bei dieser herausfordernden und spannenden Aufgabe unterstützen? Wir suchen Mitarbeitende, die mit Leidenschaft und Kompetenz an die Arbeit gehen, damit perfekte Immobilienlösungen entstehen.', :more_text => 'Als führendes Schweizer Immobilienunternehmen bieten wir eine Vielzahl von interessanten und hoch qualifizierten Berufen an. Wir übertragen unseren Mitarbeitenden Verantwortung, unterstützen sie in ihrer Laufbahnentwicklung und helfen ihnen, ihre beruflichen Fähigkeiten stetig zu erweitern. Seit über 40 Jahren bilden herausragende Mitarbeitende die Basis für unseren anhaltenden Firmenerfolg.')
  jobs_page.bricks << Brick::Accordion.new(:title => 'Der Mensch steht bei uns im Mittelpunkt', :text => 'Wir sind ein Familienunternehmen, das den Menschen mit Wertschätzung begegnet. Mitarbeitende, Kunden und Partner stehen im Zentrum unserer Tätigkeit. Unseren Mitarbeitenden bieten wir ein kollegiales und förderndes Arbeitsklima. Dazu gehört, dass wir ihnen verantwortungsvolle und herausfordernde Aufgaben übertragen und das nötige Vertrauen schenken, damit sie ihre Aufgaben unternehmerisch erfüllen können.')
  jobs_page.bricks << Brick::Accordion.new(:title => 'Weitebildung und Karriereentwicklung', :text => 'Wir möchten, dass sich unsere Mitarbeitenden laufend weiter entwickeln. Deshalb beteiligt sich die Alfred Müller AG mit 50 bis 100 Prozent an Aus- und Weiterbildungskosten, ohne dass die Mitarbeitenden eine Rückzahlungspflicht oder andere arbeitsvertragliche Verpflichtungen eingehen müssen.

Neben externen Angeboten bietet die Alfred Müller AG jedes Jahr auch zahlreiche freiwillige Seminare an. Jedem Mitarbeitenden stehen jährlich vier bezahlte Seminartage für Aus- und Weiterbildung zur Verfügung.

Bei der Alfred Müller AG gibt es keine vorgezeichneten Karrierewege. Eigenverantwortung steht im Zentrum: Mitarbeitende, die kundenorientierte Höchstleistungen erbringen, entwickeln sich bei uns schnell weiter.')
  jobs_page.bricks << Brick::Accordion.new(:title => 'Attraktive Arbeitsbedingungen', :text => 'Neben herausfordernden Aufgaben bieten wir unseren Mitarbeitenden einen leistungs- und marktorientierten Lohn sowie attraktive Personalnebenleistungen. Dazu einige Beispiele:

* Die Mitarbeitenden können bei Unfall ohne Kostenfolge weltweit die Privatabteilung beanspruchen. Die Prämien für die Betriebs- und Nichtbetriebsunfallversicherung, für die Zusatzversicherung bei Unfall sowie die Krankentaggeldversicherung werden vollumfänglich von der Firma bezahlt.
* Bei Absenzen infolge Unfall oder Krankheit bezahlt die Alfred Müller AG während sechs Monaten das volle Salär.
* Die Alfred Müller AG legt grossen Wert auf überdurchschnittliche Pensionskassenleistungen, damit die Mitarbeitenden nach der Pensionierung ihren gewohnten Lebensstandard beibehalten können.
* Die Mitarbeitenden können Beträge von bis zu zwei Jahresgehältern in den Erwerb von Global-Obligationen mit einer Verzinsung von 8 Prozent investieren.
* Nach der Geburt eines Kindes erhält der Vater einen bezahlten Vaterschaftsurlaub von fünf Tagen.
* Kindern von Mitarbeitenden bezahlt die Alfred Müller AG Entschädigungen für die Ausbildungskosten an Hochschulen oder höheren Lehranstalten.
* Mitarbeitende erhalten beim Kauf eines Eigenheims der Alfred Müller AG einen einmaligen Rabatt von maximal 30 000 Franken. Die Alfred Müller AG gewährt ihnen ausserdem eine einmalige Hypothek von maximal 100 000 Franken, wobei der Zinssatz generell um 1,5 Prozent tiefer liegt als der Zinssatz für erstrangige Wohnbauhypotheken der Zuger Kantonalbank.
* Die Tage zwischen Weihnachten und Neujahr sowie am Freitag nach Auffahrt sind arbeitsfrei ohne Ferienabzug.
* Die Alfred Müller AG stellt allen Mitarbeitenden einen Parkplatz zur Verfügung. Wer keinen Parkplatz beansprucht, erhält monatlich eine Entschädigung von 50 Franken.')
jobs_page.bricks << Brick::Accordion.new(:title => 'Familiäre Atmosphäre', :text => ' Obwohl die Alfred Müller AG bereits über 170 Mitarbeitende beschäftigt, ist die Arbeitsatmosphäre innerhalb des Unternehmens immer noch sehr familiär. In der firmeneigenen Cafeteria treffen sich die Mitarbeitenden über alle Abteilungen und Bereiche hinweg. Unsere Mitarbeitenden schätzen auch die schönen Anlässe, zu denen wir sie einladen. So finden jedes Jahr ein Geschäftsessen, ein Geschäftsausflug sowie alle fünf Jahre eine mehrtägige Jubiläumsreise statt. Neben sportlichen Aktivitäten (z.B. Bike to work, Skiweekend) können die Mitarbeitenden dreimal jährlich an gemütlichen Höcks teilnehmen. Auch die Pensionierten laden wir einmal im Jahr zu einem Tagesausflug ein.')

jobs_page.bricks << Brick::Title.new(:title => 'Offene Stellen')
jobs_page.bricks << Brick::Placeholder.new(:placeholder => 'jobs_openings')

jobs_page.bricks << Brick::Title.new(:title => 'Erfolgreich bewerben')
jobs_page.bricks << Brick::Text.new(:text => 'Möchten Sie bei uns arbeiten? Dann freuen wir uns auf Ihre Bewerbungsunterlagen. Bitte beachten Sie, dass eine umfassende, vollständige und sorgfältige Bewerbung die Grundlage für eine professionelle Auswahlentscheidung bildet. Deshalb benötigen wir von Ihnen Unterlagen, mit denen wir uns ein genaues Bild von Ihren Qualifikationen, Fähigkeiten und Ihrer Persönlichkeit machen können. ', :more_text => 'Bitte haben Sie Verständnis, dass wir Zeit brauchen, um die eingehenden Bewerbungsunterlagen sorgfältig zu prüfen. Ein erstes Feedback erhalten Sie von uns aber schon wenige Tage nach dem Eingang Ihres Dossiers.
Wenn Sie bereit sind, engagiert zu arbeiten, unternehmerisch zu denken und im Team nach optimalen Lösungen zu suchen, dann verfügen Sie bereits über die wichtigsten Voraussetzungen für eine Karriere bei der Alfred Müller AG. Je nach Stelle sind zusätzliche Anforderungen notwendig, welche Sie den einzelnen Stellenausschreibungen entnehmen können.')
jobs_page.bricks << Brick::Placeholder.new(:placeholder => 'jobs_apply_with_success')
end

end
