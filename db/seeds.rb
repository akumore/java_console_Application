# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Cms::User.create(email: 'admin@screenconcept.ch', password: 'bambus', password_confirmation: 'bambus')

module InitialCategories

  # Top level categories

  {
    'apartment' => { :label => 'Wohnung' },
    'gastronomy' => { :label => 'Gastronomie' },
    'industrial' => { :label => 'Gewerbe/Industrie' },
    'parking' => { :label => 'Parkplatz' },
    'properties' => { :label => 'Grundstück' },
    'secondary' => { :label => 'Wohnnebenräume' }
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
    create_sublevel_for('industrial', sublevel_category)
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
    }
  ]
end

