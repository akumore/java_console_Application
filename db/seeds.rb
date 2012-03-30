# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Cms::User.create(email: 'admin@screenconcept.ch', password: 'bambus', password_confirmation: 'bambus', :role => 'admin')
Cms::User.create(email: 'staging@alfred-mueller.ch', password: 'am2012', password_confirmation: 'am2012', :role => 'admin')

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
       :label => 'Lager',
       :name => 'depot'
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

        r = RealEstate.find_or_create_by(:title => 'SC Sample Object 1')
        r.state = RealEstate::STATE_EDITING
        r.utilization = RealEstate::UTILIZATION_PRIVATE
        r.offer = RealEstate::OFFER_FOR_RENT
        r.channels = [RealEstate::CHANNELS.first]
        r.reference = Reference.new(
            :property_key => 'SC P 1', :building_key => 'SC B 1', :unit_key => 'SC U 1'
        )
        r.address = Address.new(:canton => 'ag',
                                :city => 'Fahrwangen', :street => 'Bahnhofstrasse', :street_number => '18', :zip => '1234'
        )
        r.category = Category.where(:name => 'flat').first
        r.pricing = Pricing.new(:price_unit => Pricing::PRICE_UNITS.first, :for_rent_netto => 2380, :for_rent_extra => 380)
        r.figure = Figure.new(:floor => 3, :living_surface => 186)
        r.information = Information.new(:available_from => Date.parse('2012-01-21'))
        r.infrastructure = Infrastructure.new(:has_parking_spot => true)
        r.description = "Beschreibung 1!!!"
        r.additional_description = AdditionalDescription.new(:generic => 'Die Wohnung ist mit Keramikbodenplatten belegt und...')
        r.media_assets = gartenstadt_images.map { |img_path|
          MediaAsset.new(
              :media_type => MediaAsset::IMAGE,
              :is_primary => img_path==gartenstadt_images.first,
              :file => File.open(img_path),
              :title => "IMG #{File.basename(img_path)}"
          )
        }
        r.save!

        4.times do |t|
          r = RealEstate.find_or_create_by(:title => "Sample Object #{t}")
          r.state = RealEstate::STATE_EDITING
          r.utilization = RealEstate::UTILIZATION_PRIVATE
          r.offer = RealEstate::OFFER_FOR_RENT
          r.channels = [RealEstate::CHANNELS.first]
          r.reference = Reference.new(
              :property_key => "P #{t}", :building_key => "B #{t}", :unit_key => "U #{t}"
          )
          r.address = Address.new(:canton => 'ag',
                                  :city => 'Fahrwangen', :street => 'Bahnhofstrasse', :street_number => '18', :zip => '1234'
          )
          r.information = Information.new(:available_from => Date.parse('2012-01-01'))
          r.category = Category.where(:name => 'flat').first
          r.pricing = Pricing.new(:price_unit => Pricing::PRICE_UNITS.first, :for_rent_netto => 2380, :for_rent_extra => 380)
          r.figure = Figure.new(:floor => 3, :living_surface => 186)
          r.infrastructure = Infrastructure.new(:has_parking_spot => true)
          r.description = "Beschreibung 1"
          r.additional_description = AdditionalDescription.new(:generic => 'Die Wohnung ist mit Keramikbodenplatten belegt und...')
          r.save!
        end

      end
    end
  end
end


module InitialPages
  module JobsPage
    Page.create(:title => 'Jobs', :name => 'jobs', :locale => :de) do |jobs_page|
      jobs_page.bricks << Brick::Title.new(:title => 'Der Mensch steht bei uns im Mittelpunkt')
      jobs_page.bricks << Brick::Text.new(
          :text => 'Den grössten Teil unseres Lebens verbringen wir in Immobilien – sei es zuhause oder am Arbeitsplatz. Deshalb haben wir es uns zur Aufgabe gemacht, hochwertige Wohn- und Geschäftshäuser zu entwickeln, in denen sich die Menschen wohl fühlen. Wollen Sie uns bei dieser herausfordernden und spannenden Aufgabe unterstützen? Wir suchen Mitarbeitende, die mit Leidenschaft und Kompetenz an die Arbeit gehen, damit perfekte Immobilienlösungen entstehen.',
          :more_text => 'Als führendes Schweizer Immobilienunternehmen bieten wir eine Vielzahl von interessanten und hoch qualifizierten Berufen an. Wir übertragen unseren Mitarbeitenden Verantwortung, unterstützen sie in ihrer Laufbahnentwicklung und helfen ihnen, ihre beruflichen Fähigkeiten stetig zu erweitern. Seit über 40 Jahren bilden herausragende Mitarbeitende die Basis für unseren anhaltenden Firmenerfolg.'
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Der Mensch steht bei uns im Mittelpunkt',
          :text => 'Wir sind ein Familienunternehmen, das den Menschen mit Wertschätzung begegnet. Mitarbeitende, Kunden und Partner stehen im Zentrum unserer Tätigkeit. Unseren Mitarbeitenden bieten wir ein kollegiales und förderndes Arbeitsklima. Dazu gehört, dass wir ihnen verantwortungsvolle und herausfordernde Aufgaben übertragen und das nötige Vertrauen schenken, damit sie ihre Aufgaben unternehmerisch erfüllen können.'
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Weitebildung und Karriereentwicklung',
          :text => [
              'Wir möchten, dass sich unsere Mitarbeitenden laufend weiter entwickeln. Deshalb beteiligt sich die Alfred Müller AG mit 50 bis 100 Prozent an Aus- und Weiterbildungskosten, ohne dass die Mitarbeitenden eine Rückzahlungspflicht oder andere arbeitsvertragliche Verpflichtungen eingehen müssen.',
              'Neben externen Angeboten bietet die Alfred Müller AG jedes Jahr auch zahlreiche freiwillige Seminare an. Jedem Mitarbeitenden stehen jährlich vier bezahlte Seminartage für Aus- und Weiterbildung zur Verfügung.',
              'Bei der Alfred Müller AG gibt es keine vorgezeichneten Karrierewege. Eigenverantwortung steht im Zentrum: Mitarbeitende, die kundenorientierte Höchstleistungen erbringen, entwickeln sich bei uns schnell weiter.'
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Attraktive Arbeitsbedingungen',
          :text => [
              "Neben herausfordernden Aufgaben bieten wir unseren Mitarbeitenden einen leistungs- und marktorientierten Lohn sowie attraktive Personalnebenleistungen. Dazu einige Beispiele:\n",
              '* Die Mitarbeitenden können bei Unfall ohne Kostenfolge weltweit die Privatabteilung beanspruchen. Die Prämien für die Betriebs- und Nichtbetriebsunfallversicherung, für die Zusatzversicherung bei Unfall sowie die Krankentaggeldversicherung werden vollumfänglich von der Firma bezahlt.',
              '* Bei Absenzen infolge Unfall oder Krankheit bezahlt die Alfred Müller AG während sechs Monaten das volle Salär.',
              '* Die Alfred Müller AG legt grossen Wert auf überdurchschnittliche Pensionskassenleistungen, damit die Mitarbeitenden nach der Pensionierung ihren gewohnten Lebensstandard beibehalten können.',
              '* Die Mitarbeitenden können Beträge von bis zu zwei Jahresgehältern in den Erwerb von Global-Obligationen mit einer Verzinsung von 8 Prozent investieren.',
              '* Nach der Geburt eines Kindes erhält der Vater einen bezahlten Vaterschaftsurlaub von fünf Tagen.',
              '* Kindern von Mitarbeitenden bezahlt die Alfred Müller AG Entschädigungen für die Ausbildungskosten an Hochschulen oder höheren Lehranstalten.',
              '* Mitarbeitende erhalten beim Kauf eines Eigenheims der Alfred Müller AG einen einmaligen Rabatt von maximal 30 000 Franken. Die Alfred Müller AG gewährt ihnen ausserdem eine einmalige Hypothek von maximal 100 000 Franken, wobei der Zinssatz generell um 1,5 Prozent tiefer liegt als der Zinssatz für erstrangige Wohnbauhypotheken der Zuger Kantonalbank.',
              '* Die Tage zwischen Weihnachten und Neujahr sowie am Freitag nach Auffahrt sind arbeitsfrei ohne Ferienabzug.',
              '* Die Alfred Müller AG stellt allen Mitarbeitenden einen Parkplatz zur Verfügung. Wer keinen Parkplatz beansprucht, erhält monatlich eine Entschädigung von 50 Franken.'
          ].join("\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Familiäre Atmosphäre',
          :text => ' Obwohl die Alfred Müller AG bereits über 170 Mitarbeitende beschäftigt, ist die Arbeitsatmosphäre innerhalb des Unternehmens immer noch sehr familiär. In der firmeneigenen Cafeteria treffen sich die Mitarbeitenden über alle Abteilungen und Bereiche hinweg. Unsere Mitarbeitenden schätzen auch die schönen Anlässe, zu denen wir sie einladen. So finden jedes Jahr ein Geschäftsessen, ein Geschäftsausflug sowie alle fünf Jahre eine mehrtägige Jubiläumsreise statt. Neben sportlichen Aktivitäten (z.B. Bike to work, Skiweekend) können die Mitarbeitenden dreimal jährlich an gemütlichen Höcks teilnehmen. Auch die Pensionierten laden wir einmal im Jahr zu einem Tagesausflug ein.'
      )

      jobs_page.bricks << Brick::Title.new(:title => 'Offene Stellen')
      jobs_page.bricks << Brick::Placeholder.new(:placeholder => 'jobs_openings')

      jobs_page.bricks << Brick::Title.new(:title => 'Erfolgreich bewerben')
      jobs_page.bricks << Brick::Text.new(
          :text => 'Möchten Sie bei uns arbeiten? Dann freuen wir uns auf Ihre Bewerbungsunterlagen. Bitte beachten Sie, dass eine umfassende, vollständige und sorgfältige Bewerbung die Grundlage für eine professionelle Auswahlentscheidung bildet. Deshalb benötigen wir von Ihnen Unterlagen, mit denen wir uns ein genaues Bild von Ihren Qualifikationen, Fähigkeiten und Ihrer Persönlichkeit machen können. ',
          :more_text => [
              'Bitte haben Sie Verständnis, dass wir Zeit brauchen, um die eingehenden Bewerbungsunterlagen sorgfältig zu prüfen. Ein erstes Feedback erhalten Sie von uns aber schon wenige Tage nach dem Eingang Ihres Dossiers.',
              'Wenn Sie bereit sind, engagiert zu arbeiten, unternehmerisch zu denken und im Team nach optimalen Lösungen zu suchen, dann verfügen Sie bereits über die wichtigsten Voraussetzungen für eine Karriere bei der Alfred Müller AG. Je nach Stelle sind zusätzliche Anforderungen notwendig, welche Sie den einzelnen Stellenausschreibungen entnehmen können.'
          ].join("\n")
      )
      jobs_page.bricks << Brick::Placeholder.new(:placeholder => 'jobs_apply_with_success')
    end


    #Seed more JobPages above this line
    I18n.available_locales.each do |locale|
      #Trying to create an empty Jobs Page for each locale, uniqueness validation rejects us not to overwrite existing pages
      Page.create(:title => 'Jobs', :name => 'jobs', :locale => locale)
    end
  end

  module CompanyPage
    Page.create(:title => 'Unternehmen', :name => 'company', :locale => :de) do |jobs_page|
      jobs_page.bricks << Brick::Title.new(:title => 'Sie engagieren uns, damit ihr Bauprojekt gelingt')
      jobs_page.bricks << Brick::Text.new(
          :text => 'Die Alfred Müller AG gehört zu den führenden Schweizer Immobilenunternehmungen. Im Auftrag ihrer Kunden oder für ihr eigenes Portfolio entwickelt, realisiert und vermarktet sie qualitativ hochwertige Wohn- und Geschäftshäuser. Seit seiner Gründung hat das Familienunternehmen mehr als 5800 Wohnungen und 1,7 Millionen Quadratmeter Geschäftsfläche erstellt.',
          :more_text => 'Der hohe Immobilienbestand und die hohe Kapitalkraft verleihen der Alfred Müller AG eine gesunde finanzielle Basis. Diese bedeutet für ihre Kunden eine grosse Sicherheit und ist ein wichtiger Grund dafür, dass die Alfred Müller AG als Immobilieninvestorin stark gefragt ist. Als eine von wenigen im Baubereich tätigen Firmen verfügt die Alfred Müller AG bei den Banken über ein erstklassiges Kredit-Rating.'
      )
      jobs_page.bricks << Brick::Title.new(:title => 'Unsere Dienstleistungen')
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Projektentwicklung',
          :text => [
              '###Wir schaffen einen Mehrwert',
              'Eine durchdachte Planung ist bei jedem Bauwerk Grundvoraussetzung für eine erfolgreiche Nutzung und Vermarktung. Die Entwicklung marktgerechter und qualitativ hochstehender Immobilienprojekte ist seit fast 50 Jahren die Kernkompetenz der Alfred Müller AG. Bei Geschäftsgebäuden legen wir Wert auf eine multifunktionale und flexible Nutzung der nach neustem Baustandard erstellten und mit modernster Gebäudetechnik ausgestatteten Flächen. Bei Eigenheimen setzen wir auf bewährte, langlebige Materialien und kluge Raumlayouts. Unseren Käufern räumen wir grösstmögliche Gestaltungsfreiheit beim Innenausbau ein. Damit Wohnträume wahr werden können.',
              '###Unsere Leistungen',
              [
                  '* Strategische Planung',
                  '* Machbarkeitsstudien',
                  '* Grundstücksanalysen',
                  '* Marktanalysen',
                  '* Gebäudeanalysen',
                  '* Rechtliche Analysen',
                  '* Nutzungsanalysen',
                  '* Kostenanalysen'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[Andreas Büchle](mailto:andreas.buechle@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Bauausführung',
          :text => [
              '###Wir geben Ihren Ideen eine Form',
              'Als General- oder Totalunternehmen entlasten wir unsere Auftraggeber weitgehend von allen Umtrieben, die ein Bauprojekt mit sich bringt. Wir begleiten und beraten unsere Kunden bei der Planung des Projekts, organisieren und koordinieren den Bauablauf und erstellen das Gebäude für sie schlüsselfertig. Wir stehen ihnen als kompetenter und engagierter Ansprechpartner während der gesamten Planungs- und Realisierungsphase zur Seite und haften erst noch für Preis, Termin und Qualität. ',
              '###Unsere Leistungen',
              [
                  '* Projektdefinition',
                  '* Kostenschätzung und Kostenvoranschlag',
                  '* Vorbereitung und Begleitung des Bewilligungsverfahrens',
                  '* Totalunternehmerauftrag: Leitung des Projekts von der Planung bis zur schlüsselfertigen Übergabe',
                  '* Generalunternehmerauftrag: Leitung des Projekts ab Planung bis zur schlüsselfertigen Übergabe',
                  '* Termin- und Kostenkontrolle',
                  '* Qualitätsmanagement',
                  '* Organisation und Überwachung der Garantiearbeiten'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[Offen](mailto:offen@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Umbau und Renovation',
          :text => [
              '###Wir sorgen dafür, dass Ihre Liegenschaft ihren Wert behält ',
              'Bauwerke mit qualitativ guter Rohbaustruktur können problemlos mehr als hundert Jahre überdauern. Wird ein Gebäude jedoch nicht unterhalten, verschlechtert sich seine Bausubstanz mit der Zeit sehr stark. Wer seine Liegenschaft unter-hält, spart letztlich Geld, denn er kann den Wert der Immobilie erhalten, Leerstände und Mietzinsverluste vermeiden, die Betriebskosten reduzieren und Ertrag sowie Rendite langfristig sichern. Die Alfred Müller AG verfügt im Bereich Umbau und Renovation über eine langjährige Erfahrung und kennt als grosse Immobilienbesitzerin die möglichen Problemstellungen bestens. Sie berät ihre Kunden als kompetente Partnerin bei der Planung und garantiert bei der Umsetzung für Qualität, Preis und Termin.',
              '###Unsere Leistungen',
              [
                  '* Machbarkeitsüberprüfung',
                  '* Projektdefinition',
                  '* Kostenschätzung und Kostenvoranschlag',
                  '* Vorbereitung und Begleitung des Bewilligungsverfahrens',
                  '* Ausschreibungen',
                  '* Bauausführung',
                  '* Termin- und Kostenkontrolle',
                  '* Qualitätsmanagement',
                  '* Organisation und Überwachung der Garantiearbeiten'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[Bruno Gallizia](mailto:bruno.gallizia@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Vermarktung',
          :text => [
              '###Wir verhelfen Ihrer Immobilie zum Erfolg',
              'Kunden, für die wir Bauten realisieren, bieten wir auch den Verkauf oder die Erstvermietung ihrer Wohn-, Büro und Gewerberäumen an. Dank unseren profunden Marktkenntnissen und unserer langjährigen Erfahrungen wissen wir genau, welche Marketingmassnahmen und Werbemittel in der Immobilien-Vermarktung erfolgreich sind.',
              '###Unsere Leistungen',
              [
                  '* Grundstück- und Marktanalysen',
                  '* Vermarktungskonzepte',
                  '* Beratung bei Grundrissgestaltung und Ausbaustandard',
                  '* Definition von Mietzinsen, Verkaufspreisen und Wertquoten inkl. Nebenkosten',
                  '* Erstellung von Marketing-, Beschriftungs- und Parkkonzepten',
                  '* Ausarbeitung von Vermietungs- und Verkaufsunterlagen',
                  '* Gestalten und Platzieren von Werbemitteln und -aktionen',
                  '* Ausarbeitung von Miet-/Kaufverträgen und allfälligen Zusatzverträgen',
                  '* Verhandeln mit Miet- und Kaufinteressenten'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[David Spiess](mailto:david.spiess@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Fascility Management',
          :text => [
              '###Wir sorgen dafür, dass die Rendite langfristig stimmt',
              'Kunden, für die wir Gebäude erstellt haben, bieten wir auch unsere professionelle Immobilienbewirtschaftung an. Wir sind Mitglied des Schweizerischen Verbandes für Immobilienwirtschaft und verfügen über ein kompetentes und erfahrenes Team, das schon heute 800 000 m² Büro- und Gewerbeflächen sowie rund 4400 Mietwohnungen und Eigenheime betreut. Unsere Mitarbeitenden übernehmen dabei die administrative und technische Bewirtschaftung von Wohnliegenschaften, Stockwerk- und Miteigentum, Gewerbe- und Dienstleistungsobjekten sowie Geschäfts-häusern. Oberstes Ziel ist die optimale Werterhaltung eines Gebäudes, damit Sie langfristig eine marktgerechte Rendite erzielen können.',
              '###Unsere Leistungen',
              [
                  '* Abrechnungs- und Versicherungswesen',
                  '* Inkasso Mietzinse und Nebenkosten',
                  '* Wiedervermietung',
                  '* Leitung von Eigentümerversammlungen',
                  '* Anstellung/Coaching Hauswart',
                  '* Koordination des technischen Unterhalts',
                  '* Zustandskontrollen/Berichterstattung',
                  '* Schadenregulierung mit Versicherungen',
                  '* Beratung bei Investitionen/Sanierungen'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[Walter Hochreutener](mailto:walter.hochreutener@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Accordion.new(
          :title => 'Gartenunterhalt',
          :text => [
              '###Damit Sie sich von Anfang an in Ihrem neuen Zuhause wohl fühlen',
              'Die Gestaltung von Grün- und Freiflächen in Wohnsiedlungen und Geschäftsarealen geniesst bei der Alfred Müller AG einen hohen Stellenwert ein. Sie beschäftigt deshalb eine eigene Abteilung Garten- und Landschaftsbau, die inzwischen über 20 Mitarbeitende beschäftigt. Diese sorgen dafür, dass Grünflächen rechtzeitig geplant und professionell bepflanzt werden. Bei grösseren Projekten arbeitet der Gartenbau auch oft mit Gartenarchitekten zusammen. Er führt auch Aufträge von Dritten aus, beispielsweise für den Gartenunterhalt.',
              '###Unsere Leistungen',
              [
                  '* Planung, Anlage und Unterhalt von Gärten, Rasenplätzen, Bepflanzungen, Dach- und Balkonbegrünungen',
                  '* Bau von Wegen, Strassen, Zäunen, Kanalisationen, Spielplätzen'
              ].join("\n"),
              [
                  '###Ihr Ansprechpartner',
                  '[Thomas Meierhans](mailto:thomas.meierhans@alfred-mueller.ch)'
              ].join("\n")
          ].join("\n\n")
      )
      jobs_page.bricks << Brick::Title.new(:title => 'Unsere Vision')
      jobs_page.bricks << Brick::Text.new(
          :text => 'Wir schaffen hochwertige Wohn- und Arbeitsräume, in denen Menschen sich wohl fühlen. Mit Leidenschaft und Kompetenz gehen wir an die Arbeit, damit perfekte Immobiliengesamtlösungen entstehen. Gemeinsam verfolgen wir ein Ziel: wir bieten unseren Kunden, Mitarbeitenden und Partnern einen Mehrwert.',
          :more_text => ''
      )
      jobs_page.bricks << Brick::Title.new(:title => 'Kennzahlen 2011')
      jobs_page.bricks << Brick::Text.new(
          :text => [
              '* **Gründung:** 1965, Inhaber: Alfred Müller-Stocker, Baar',
              '* **Aktienkapital:** 30 Mio. CHF',
              '* **Jahresumsatz:** 364 Mio. CHF',
              '* **Anzahl Mitarbeiter:** 181',
              '* **Hauptsitz:** Alfred Müller AG, Baar',
              '* **Filialen:** Alfred Müller SA, Marin/NE, Alfred Müller SA, Camorino/TI'
          ].join("\n"),
          :more_text => ''
      )
      jobs_page.bricks << Brick::Title.new(:title => 'Hohes Qualitätsbewusstsein')
      jobs_page.bricks << Brick::Text.new(
          :text => [
              'Seit ihrer Gründung pflegt die Alfred Müller AG ein ausgeprägtes Qualitätsbewusstsein. Bei ihren Projekten setzt sie auf bewährte und langlebige Produkte und Standards, damit Bauten entstehen, an denen Nutzer und Eigentümer lange Freude haben.',
              'Um den steigenden Anforderungen und ständigen Neuentwicklungen im Markt gerecht zu werden, fördert die Alfred Müller AG die Aus- und Weiterbildung ihrer Mitarbeitenden gezielt. Ihren Kunden bietet sie aus einer Hand umfassende Dienstleistungen an, die den gesamten Lebenszyklus einer Immobilie umfassen.'
          ].join("\n\n"),
          :more_text => ''
      )
      jobs_page.bricks << Brick::Title.new(:title => 'Zertifizierung')
      jobs_page.bricks << Brick::Text.new(
          :text => [
              'Aufbauend auf einer fast 50jährigen Erfahrung im Hochbau verfügt die Alfred Müller AG über mehrere Qualitätssicherungs-Zertifikate.',
              'Von der «Schweizerischen Vereinigung für Qualitäts- und Management-Systeme» (SQS) wurde die gesamte Firmen-Gruppe nach ISO 9001 zertifiziert. Die Alfred Müller AG verfügt zudem über das VSGU-Label des Verbandes Schweizerischer Generalunternehmer. Dieses bezieht sich wie auch das ISO-Zertifikat auf sämtliche Bereiche der Firma.'
          ].join("\n\n"),
          :more_text => ''
      )
    end


    #Seed more CompanyPages above this line
    I18n.available_locales.each do |locale|
      #Trying to create an empty Company Page for each locale, uniqueness validation rejects us not to overwrite existing pages
      Page.create(:title => 'Company', :name => 'company', :locale => locale)
    end
  end


  module ContactPage
    Page.create(:title => 'Kontakt', :name => 'contact', :locale => :de) do |contact_page|
      contact_page.bricks << Brick::Title.new(:title => 'Kontaktieren Sie uns')
      contact_page.bricks << Brick::Placeholder.new(:placeholder => 'contact_form')
      contact_page.bricks << Brick::Title.new(:title => 'Standorte')
      contact_page.bricks << Brick::Accordion.new(
          :title => 'Baar',
          :text => [
              'Alfred Müller AG<br>Neuhofstrasse 10<br>CH-6340 Baar<br>[mail@alfred-mueller.ch](mailto:mail@alfred-mueller.ch)',
              'Tel. +41 41 767 02 02<br>Fax +41 41 767 02 00',
              '<a href="http://g.co/maps/rnwvh">![Anfahrtsplan](http://maps.google.com/maps/api/staticmap?center=47.189495,8.513978&zoom=13&markers=47.189495,8.513978&size=680x400&sensor=true)</a>'
          ].join("\n\n")
      )
      contact_page.bricks << Brick::Accordion.new(
          :title => 'Marin',
          :text => [
              'Alfred Müller SA<br>Av. des Champs-Montants 10a<br>CH-2074 Marin<br>[mail@alfred-mueller.ch](mailto:mail@alfred-mueller.ch)',
              '<a href="http://g.co/maps/qqxvt">![Anfahrtsplan](http://maps.google.com/maps/api/staticmap?center=47.012960,6.999962&zoom=13&markers=47.189495,8.513978|47.012960,6.999962&size=680x400&sensor=true)</a>'
          ].join("\n\n")
      )
      contact_page.bricks << Brick::Accordion.new(
          :title => 'Camorino',
          :text => [
              'Alfred Müller SA<br>Centro Monda 3<br>CH-6568 Camorino<br>[mail@alfred-mueller.ch](mailto:mail@alfred-mueller.ch)',
              'Tel. +41 91 858 25 94<br>Fax +41 91 858 25 54',
              '<a href="http://g.co/maps/wej9x">![Anfahrtsplan](http://maps.google.com/maps/api/staticmap?center=46.163587,9.005283&zoom=13&markers=47.189495,8.513978|47.012960,6.999962|46.163587,9.005283&size=680x400&sensor=true)</a>'
          ].join("\n\n")
      )
    end


    #Seed more ContactPages above this line
    I18n.available_locales.each do |locale|
      #Trying to create an empty Contact Page for each locale, uniqueness validation rejects us not to overwrite existing pages
      Page.create(:title => 'Contact', :name => 'contact', :locale => locale)
    end
  end


  module InitialNewsItems
    my_unique_creation_time = Time.parse('2012-03-30 11:30:00')
    NewsItem.create(
        :created_at => my_unique_creation_time,
        :locale=>:de,
        :date => Date.parse('2012-05-14'),
        :title => %(Messe ImmoMarkt der Zuger Kantonalbank),
        :teaser => %(Besuchen Sie unseren Stand am ImmoMarkt 2012 der Zuger Kantonalbank.),
        :content => [
            %(Besuchen Sie unseren Stand Nr. 1-3 am ImmoMarkt 2012 der Zuger Kantonalbank in der Waldmannhalle in Baar.),
            %(Öffnungszeiten),
            %(Montag, 14. Mai 2012, 17 bis 21 Uhr),
            %(Dienstag,15. Mai 2012, 17 bis 21 Uhr),
            %(\nWir freuen uns auf Ihren Besuch.)
        ].join("\n")
    ) unless NewsItem.where(:created_at=>my_unique_creation_time).exists? #Avoids to double-create the item if changed via CMS

    my_unique_creation_time = Time.parse('2012-03-30 11:30:11')
    NewsItem.create(
        :created_at => my_unique_creation_time,
        :locale=>:de,
        :date => Date.parse('2012-05-21'),
        :title => %(Vermarktungsstart «Gartenstadt» Schlieren, Mietwohnungen),
        :teaser => %(Weitere Details zu unseren 2½ bis 4½-Zimmer-Wohnungen sowie Ateliers finden Sie unter [www.gartenstadt-schlieren.ch](http://www.gartenstadt-schlieren.ch)),
        :content => %(Weitere Details zu unseren 2½ bis 4½-Zimmer-Wohnungen sowie Ateliers finden Sie unter [www.gartenstadt-schlieren.ch](http://www.gartenstadt-schlieren.ch)),
        :images => [
            #TODO
        ]
    ) unless NewsItem.where(:created_at=>my_unique_creation_time).exists? #Avoids to double-create the item if changed via CMS

    my_unique_creation_time = Time.parse('2012-03-30 11:30:22')
    NewsItem.create(
        :created_at => my_unique_creation_time,

        :date => Date.parse('2012-06-04'),
        :title => %(Vermarktungsstart «Feldpark» Zug, Eigentumswohnungen),
        :teaser => %(In der 3. Etappe verkaufen wir 20 Eigentumswohnungen mit 4½ und 5½ Zimmern.),
        :content => %(In der 3. Etappe verkaufen wir 20 Eigentumswohnungen mit 4½ und 5½ Zimmern.),
        :images => [
            #TODO
        ]
    ) unless NewsItem.where(:created_at=>my_unique_creation_time).exists? #Avoids to double-create the item if changed via CMS
  end
end