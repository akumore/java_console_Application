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
        r.figure = Figure.new(:floor=>3)
        r.infrastructure = Infrastructure.new(:has_parking_spot=>true)
        r.description = Description.new(:generic=>'Die Wohnung ist mit Keramikbodenplatten belegt und...')
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
          r.category = Category.where(:name=>'flat').first
          r.pricing = Pricing.new(:price_unit=>Pricing::PRICE_UNITS.first, :for_rent_netto=>2380, :for_rent_extra=>380)
          r.figure = Figure.new(:floor=>3)
          r.infrastructure = Infrastructure.new(:has_parking_spot=>true)
          r.description = Description.new(:generic=>'Die Wohnung ist mit Keramikbodenplatten belegt und...')
          r.save!
        end

      end
    end
  end

end

