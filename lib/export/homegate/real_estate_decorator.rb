# encoding: utf-8

module Export::Homegate
  class RealEstateDecorator < ApplicationDecorator
    decorates :real_estate
    allows  :version,
            :sender_id,
            :object_category,
            :object_type,
            :offer_type,
            :ref_property,
            :ref_house,
            :ref_object,
            :object_street,
            :object_zip,
            :object_city,
            :object_state,
            :object_country,
            :region,
            :object_situation,
            :available_from,
            :object_title,
            :object_description,
            :selling_price,
            :rent_net,
            :rent_extra,
            :price_unit,
            :currency,
            :gross_premium,
            :floor,
            :number_of_rooms,
            :number_of_apartments,
            :surface_living,
            :surface_property,
            :surface_usable,
            :volume,
            :year_built,
            :prop_view,
            :prop_fireplace,
            :prop_cabletv,
            :prop_elevator,
            :prop_child_friendly,
            :prop_parking,
            :prop_garage,
            :prop_balcony,
            :prop_roof_floor,
            :distance_public_transport,
            :distance_shop,
            :distance_kindergarten,
            :distance_school1,
            :distance_school2,
            :picture_1_filename,
            :picture_2_filename,
            :picture_3_filename,
            :picture_4_filename,
            :picture_5_filename,
            :picture_1_title,
            :picture_2_title,
            :picture_3_title,
            :picture_4_title,
            :picture_5_title,
            :picture_1_description,
            :picture_2_description,
            :picture_3_description,
            :picture_4_description,
            :picture_5_description,
            :movie_filename,
            :movie_title,
            :movie_description,
            :document_filename,
            :document_title,
            :document_description,
            :url,
            :agency_id,
            :agency_name,
            :agency_name_2,
            :agency_reference,
            :agency_street,
            :agency_zip,
            :agency_city,
            :agency_country,
            :agency_phone,
            :agency_mobile,
            :agency_fax,
            :agency_email,
            :agency_logo,
            :visit_name,
            :visit_phone,
            :visit_email,
            :visit_remark,
            :publish_until,
            :destination,
            :picture_6_filename,
            :picture_7_filename,
            :picture_8_filename,
            :picture_9_filename,
            :picture_6_title,
            :picture_7_title,
            :picture_8_title,
            :picture_9_title,
            :picture_6_description,
            :picture_7_description,
            :picture_8_description,
            :picture_9_description,
            :picture_1_url,
            :picture_2_url,
            :picture_3_url,
            :picture_4_url,
            :picture_5_url,
            :picture_6_url,
            :picture_7_url,
            :picture_8_url,
            :picture_9_url,
            :distance_motorway,
            :ceiling_height,
            :hall_height,
            :maximal_floor_loading,
            :carrying_capacity_crane,
            :carrying_capacity_elevator,
            :isdn,
            :wheelchair_accessible,
            :animal_allowed,
            :ramp,
            :lifting_platform,
            :railway_terminal,
            :restrooms,
            :water_supply,
            :sewage_supply,
            :power_supply,
            :gas_supply,
            :municipal_info,
            :own_object_url,
            :billing_anrede,
            :billing_first_name,
            :billing_name,
            :billing_company,
            :billing_street,
            :billing_post_box,
            :billing_zip,
            :billing_place_name,
            :billing_land,
            :billing_phone_1,
            :billing_phone_2,
            :billing_mobile,
            :billing_language,
            :publishing_id,
            :delivery_id,
            :picture_10_filename,
            :picture_11_filename,
            :picture_12_filename,
            :picture_13_filename,
            :picture_10_title,
            :picture_11_title,
            :picture_12_title,
            :picture_13_title,
            :picture_10_description,
            :picture_11_description,
            :picture_12_description,
            :picture_13_description,
            :picture_10_url,
            :picture_11_url,
            :picture_12_url,
            :picture_13_url,
            :commission_sharing,
            :commission_own,
            :commission_partner,
            :agency_logo_2,
            :number_of_floors,
            :year_renovated,
            :flat_sharing_community,
            :corner_house,
            :middle_house,
            :building_land_connected,
            :gardenhouse,
            :raised_ground_floor,
            :new_building,
            :old_building,
            :under_building_laws,
            :under_roof,
            :swimmingpool,
            :minergie_general,
            :minergie_certified,
            :last_modified,
            :advertisement_id,
            :sparefield_1,
            :sparefield_2,
            :sparefield_3,
            :sparefield_4

    def initialize(real_estate, asset_paths)
      @asset_paths = asset_paths
      super(real_estate)
    end

    def version
      #str(50) IDX3.01
      'IDX3.01'
    end

    def sender_id
      # str(50) Name of the used tool and export versionnumber (eg. Sigmasoft_v2.11, excelsior 21.23, immotools v1.99 ...)
      'AlfredMuellerWebsite_HomegateExporter'
    end

    def object_category
      # str(25) APPT','HOUSE','INDUS','PROP','GASTRO','AGRI','PARK','GARDEN','SECONDARY' (see list on tab "ObjectCategory")
      {
        'apartment' => 'APPT',
        'gastronomy' => 'GASTRO',
        'house' => 'HOUSE',
        'industrial' => 'INDUS',
        'parking' => 'PARK',
        'properties' => 'PROP',
        'secondary' => 'SECONDARY'
      }[top_level_category_name || category_name]
    end

    def object_type
      # int(3)  see list on tab "ObjectCategory"
      cat = top_level_category_name || category_name
      subcategories = {}

      if cat == 'apartment'
        subcategories = {
          'flat'            => 1,
          'duplex'          => 2,
          'attic_flat'      => 3,
          'roof_flat'       => 4,
          'studio'          => 5,
          'single_room'     => 6,
          'furnished_flat'  => 7,
          'terrace_flat'    => 8,
          # Einlieger Wohnung not used
          'loft'            => 10
        }
      elsif cat == 'gastronomy'
        subcategories = {
          'hotel'       => 1,
          'restaurant'  => 2,
          'coffeehouse' => 3
          # more, but not used
        }
      elsif cat == 'house'
        subcategories = {
           'single_house'       => 1,
           'row_house'          => 2,
           'bifamilar_house'    => 3,
           'terrace_house'      => 4,
           'villa'              => 5,
           'farm_house'         => 6,
           'multiple_dwelling'  => 7
           # more, but not used
        }
      elsif cat == 'industrial'
        subcategories = {
          'office'                      => 1,
          'shop'                        => 2,
          'advertising_area'            => 3,
          'commercial'                  => 4,
          'depot'                       => 5,
          'practice'                    => 6,
          'kiosk'                       => 7,
          'garage'                      => 10,
          'bakery'                      => 13,
          'hairdresser'                 => 14,
          'factory'                     => 16,
          'industrial_object'           => 17,
          'aterlier'                    => 19,
          'living_commercial_building'  => 20,
          'workshop'                    => 28,
          'department_store'            => 34,
          'display_window'              => 36,
          'parking_garage'              => 37,
          'parking_surface'             => 38
          # numbers are not linear!
        }
      elsif cat == 'parking'
        {
          'open_slot'                   => 1,
          'covered_slot'                => 2,
          'single_garage'               => 3,
          'double_garage'               => 4,
          'underground_slot'            => 5,
          'covered_parking_place_bike'  => 9,
          'outdoor_parking_place_bike'  => 10
          # more here, but unsused
        }
      elsif cat == 'properties'
        subcategories = {
          'building_land'     => 1,
          'agricultural_land' => 2,
          'commercial_land'   => 3,
          'industrial_land'   => 4
        }
      elsif cat == 'secondary'
        subcategories = {
          'hobby_room' => 0
        }
      end

      subcategories[model.category.name]
    end

    def offer_type
      #  str(200)  RENT','SALE'
      if model.for_rent?
        'RENT'
      elsif model.for_sale?
        'SALE'
      end
    end

    def ref_property
      #  str(80) at least one of the refs must be non blank (the word null as a value in ref_object cannot be used)
      model.try(:address).try(:reference).try(:property_key).presence
    end

    def ref_house
      # str(80) the word null as a value in ref_house cannot be used
      model.try(:address).try(:reference).try(:building_key).presence
    end

    def ref_object
      #  str(80) the word null as a value in ref_object cannot be used
      model.try(:address).try(:reference).try(:unit_key).presence
    end

    def object_street
      # str(200)  must field (exact match of street and number) for the geographical search on map.homegate.ch
      [model.try(:address).try(:street).presence, model.try(:address).try(:street_number).presence].compact.join ' '
    end

    def object_zip
      # str(10) If country CH must be a valid 4 digit code (http://www.post.ch). If blank zip code and not in country CH then allow zip code with constant 'nozip'
      model.try(:address).try(:zip).presence
    end

    def object_city
      # str(200)
      model.try(:address).try(:city).presence
    end

    def object_state
      #  str(2)  ZH, AG etc.
      model.try(:address).try(:canton).try(:upcase)
    end

    def object_country
      #  str(2)  A2 ISO codes <http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html>
      'CH'
    end

    def region
      #  str(200)  not used
    end

    def object_situation
      #  str(50) remarkable situation within the city or town. eg: 'centre ville'
      # AM: obsolete
    end

    def available_from
      #  date  if empty="on request" / Date (DD.MM.YYYY)=Date / Date in past or current date=immediately
      if model.try(:information).try(:available_from).present?
        model.information.available_from.strftime("%d.%m.%Y")
      end
    end

    def object_title
      #  str(70) eyecatcher, title of advertisement
      model.title.presence
    end

    def object_description
      #  str(4000) biggest varchar2(4000) in oracle - split description into two parts if required.
      # The following HTML-Tags can be used: <LI>,</LI>,<BR>, <B>,</B>. All other Tags will be removed.
      html = RDiscount.new(model.description.presence.to_s).to_html
      Sanitize.clean(html, :elements => ['b', 'li', 'br'])
    end

    def selling_price
      # int(10) round up / selling_price OR rent_net  is mandatory / empty="by request" - if offer_type = RENT: total rent price - if offer_type = SALE: total sellingprice

      if model.for_rent?
        model.try(:pricing).try(:for_rent_netto).presence.to_i + model.try(:pricing).try(:for_rent_extra).presence.to_i
      end

      if model.for_sale?
        model.try(:pricing).try(:for_sale)
      end
    end

    def rent_net
      #  int(10) round up / selling_price OR rent_net  is mandatory / empty="by request"
      model.try(:pricing).try(:for_rent_netto).presence
    end

    def rent_extra
      #  int(10) round up
      model.try(:pricing).try(:for_rent_extra).presence
    end

    def price_unit
      #  str(10) SELL','SELLM2','YEARLY','M2YEARLY','MONTHLY','WEEKLY','DAILY' (related to field offer_type)
      if model.pricing.present?
        {
          'monthly' => 'MONTHLY',
          'yearly'  => 'YEARLY',
          'weekly'  => 'WEEKLY',
          'daily'   => 'DAILY',
          'year_m2' => 'M2YEARLY',
          'sell'    => 'SELL',
          'sell_m2' => 'SELLM2'
        }[model.pricing.price_unit]
      end
    end

    def currency
      #  str(3)  (alpha ISO codes <http://www.xe.com/iso4217.htm>)
      'CHF'
    end

    def gross_premium
      # str(19) 2-3','3-4','4-5','5-6','6-7','7-8','8+' (in %) (offer_type=SALE & Category=HOUSE & Type=7 only)
      # TODO: throw 'gross_premium needs to be implemented'
    end

    def floor
      # int(6)  floor filter see on tab "Floor filter"
      model.try(:figure).try(:floor).presence
    end

    def number_of_rooms
      # int(5,1)  number of rooms in object itself
      model.try(:figure).try(:rooms)
    end

    def number_of_apartments
      #  int(5,1)  number of appartments in object itself
      # AM: obsoleted
    end

    def surface_living
      #  int(10) remove any non-digits
      model.try(:figure).try(:living_surface).presence.to_i
    end

    def surface_property
      #  int(10) remove any non-digits
      model.try(:figure).try(:property_surface).presence.to_i
    end

    def surface_usable
      #  int(10) remove any non-digits
      model.try(:figure).try(:usable_surface).presence.to_i
    end

    def volume
      #  int(10) remove any non-digits
      # AM: obsoleted
    end

    def year_built
      #  int(4)  year object has been built, a.e. 1975
      model.try(:figure).try(:built_on).presence.to_i
    end

    def prop_view
      # str(1)  object has view, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_outlook) ? 'Y' : 'N'
    end

    def prop_fireplace
      #  str(1)  object has fireplace, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_fireplace) ? 'Y' : 'N'
    end

    def prop_cabletv
      #  str(1)  object has cable tv connection, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      # AM: obsolete
    end

    def prop_elevator
      # str(1)  object has elevator, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_elevator) ? 'Y' : 'N'
    end

    def prop_child_friendly
      # actual key: prop_child-friendly (with dash)
      # str(1)  object is locarted child friendly, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_child_friendly) ? 'Y' : 'N'
    end

    def prop_parking
      #  str(1)  object has parking lot, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:infrastructure).try(:has_parking_spot) ? 'Y' : 'N'
    end

    def prop_garage
      # str(1)  object has garage place, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:infrastructure).try(:has_garage) ? 'Y' : 'N'
    end

    def prop_balcony
      #  str(1)  object has balcony, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_balcony) ? 'Y' : 'N'
    end

    def prop_roof_floor
      # str(1)  not used
    end

    def distance_public_transport
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'public_transport').try(:first).try(:distance).to_i
      end
    end

    def distance_shop
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'shopping').try(:first).try(:distance).to_i
      end
    end

    def distance_kindergarten
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'kindergarden').try(:first).try(:distance).to_i
      end
    end

    def distance_school1
      #  int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'elementary_school').try(:first).try(:distance).to_i
      end
    end

    def distance_school2
      #  int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'high_school').try(:first).try(:distance).to_i
      end
    end

    def movie_filename
      #  str(200)  filename without path, eg: 'movie.avi' - valid movie types = mov, avi, rpm, mpeg, mpg, wmv, mp4, flv (movies must be transfered in directory "movies")
      @asset_paths[:videos].try(:first)
    end

    def movie_title
      # str(200)  title of movie
      model.videos.try(:first).try(:title).presence
    end

    def movie_description
      # str(1800) not used
    end

    def document_filename
      # str(200)  filename w/o path, eg: 'doc.pdf' - valid document types = pdf/rtf/doc (docs must be transfered in directory "docs")
      @asset_paths[:documents].try(:first)
    end

    def document_title
      #  str(200)  title of document
      model.documents.try(:first).try(:title).presence
    end

    def document_description
      #  str(1800) not used
    end

    def url
      # str(200)  only displayed if different to agency URL and if object contains more than 4 pictures - Product ImmoViewer = URL must start with "http://www.immoviewer.ch/"
      model.try(:address).try(:link_url).presence
    end

    def agency_id
      # str(10) given by homegate (Info: agency_id + ref_property + ref_object + ref_house forms the unique object key)
      Settings.homegate.agency_id
    end

    def agency_name
      # str(200)
      'Alfred Müller AG'
    end

    def agency_name_2
      # str(255)
    end

    def agency_reference
      #  str(200)  (real estate contact person)
      model.try(:contact).try(:fullname).presence
    end

    def agency_street
      # str(200)
      'Neuhofstrasse 10'
    end

    def agency_zip
      #  str(200)  blank allowed for pool agencies
      '6340'
    end

    def agency_city
      # str(200)
      'Baar'
    end

    def agency_country
      #  str(2)  A2 ISO codes <http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html> - if blank then default to 'CH'
      'CH'
    end

    def agency_phone
      #  str(200)
      model.try(:contact).try(:phone).presence || '+41 41 767 02 02'
    end

    def agency_mobile
      # str(200)  not used
      model.try(:contact).try(:mobile).presence
    end

    def agency_fax
      #  str(200)
      model.try(:contact).try(:fax).presence || '+41 41 767 02 00'
    end

    def agency_email
      #  str(200)  if empty=default e-mailadress of agency will be used - if filled=e-mail will be used for this record only
      model.try(:contact).try(:email)
    end

    def agency_logo
      # str(200)  not used - default of agency will be used or http://www.homegate.ch/neutral/img/logos/l_xxx.gif
    end

    def visit_name
      #  str(200)  Contact person to visit the object
      # AM: obsolete
    end

    def visit_phone
      # str(200)  Contact person phone number (mobile number or fix number)
      # AM: obsolete
    end

    def visit_email
      # str(200)  not used
      # AM: obsolete
    end

    def visit_remark
      #  str(200)  Contact Person comment e.g. object can be visited on Monday from 5-7p.m.
      # AM: obsolete
    end

    def publish_until
      # date  not used
    end

    def destination
      # str(200)  not used
    end

    def picture_1_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][0] rescue nil
    end

    def picture_2_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][1] rescue nil
    end

    def picture_3_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][2] rescue nil
    end

    def picture_4_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][3] rescue nil
    end

    def picture_5_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][4] rescue nil
    end

    def picture_6_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][5] rescue nil
    end

    def picture_7_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][6] rescue nil
    end

    def picture_8_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][7] rescue nil
    end

    def picture_9_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][8] rescue nil
    end

    def picture_10_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][9] rescue nil
    end

    def picture_11_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][10] rescue nil
    end

    def picture_12_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][11] rescue nil
    end

    def picture_13_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
      @asset_paths[:images][12] rescue nil
    end

    def picture_1_title
      # str(200)  title of picture
      model.images.to_a[0].title rescue nil
    end

    def picture_2_title
      # str(200)  title of picture
      model.images.to_a[1].title rescue nil
    end

    def picture_3_title
      # str(200)  title of picture
      model.images.to_a[2].title rescue nil
    end

    def picture_4_title
      # str(200)  title of picture
      model.images.to_a[3].title rescue nil
    end

    def picture_5_title
      # str(200)  title of picture
      model.images.to_a[4].title rescue nil
    end

    def picture_6_title
      # str(200)  title of picture
      model.images.to_a[5].title rescue nil
    end

    def picture_7_title
      # str(200)  title of picture
      model.images.to_a[6].title rescue nil
    end

    def picture_8_title
      # str(200)  title of picture
      model.images.to_a[7].title rescue nil
    end

    def picture_9_title
      # str(200)  title of picture
      model.images.to_a[8].title rescue nil
    end

    def picture_10_title
      #  str(200)  title of picture
      model.images.to_a[9].title rescue nil
    end

    def picture_11_title
      #  str(200)  title of picture
      model.images.to_a[10].title rescue nil
    end

    def picture_12_title
      #  str(200)  title of picture
      model.images.to_a[11].title rescue nil
    end

    def picture_13_title
      #  str(200)  title of picture
      model.images.to_a[12].title rescue nil
    end

    def picture_1_description
      # str(1800) description of picture
    end

    def picture_2_description
      # str(1800) description of picture
    end

    def picture_3_description
      # str(1800) description of picture
    end

    def picture_4_description
      # str(1800) description of picture
    end

    def picture_5_description
      # str(1800) description of picture
    end

    def picture_6_description
      # str(1800) description of picture
    end

    def picture_7_description
      # str(1800) description of picture
    end

    def picture_8_description
      # str(1800) description of picture
    end

    def picture_9_description
      # str(1800) description of picture
    end

    def picture_10_description
      #  str(1800) description of picture
    end

    def picture_11_description
      #  str(1800) description of picture
    end

    def picture_12_description
      #  str(1800) description of picture
    end

    def picture_13_description
      #  str(1800) description of picture
    end

    def picture_1_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_2_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_3_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_4_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_5_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_6_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_7_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_8_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_9_url
      # str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_10_url
      #  str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_11_url
      #  str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_12_url
      #  str(200)  homegate.ch export only: URL to picture format large
    end

    def picture_13_url
      #  str(200)  homegate.ch export only: URL to picture format large
    end

    def distance_motorway
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
      if model.infrastructure.present?
        model.infrastructure.points_of_interest.where(:name => 'highway_access').try(:first).try(:distance).to_i
      end
    end

    def ceiling_height
      #  int(10,2) height of room in meters
      model.try(:figure).try(:ceiling_height)
    end

    def hall_height
      # int(10,2) height of hall in meters
      model.try(:figure).try(:ceiling_height)
    end

    def maximal_floor_loading
      # int(10,1) kg/m2
      model.try(:information).try(:maximal_floor_loading).presence
    end

    def carrying_capacity_crane
      # int(10,1) kg
    end

    def carrying_capacity_elevator
      #  int(10,1) kg
      model.try(:information).try(:freight_elevator_carrying_capacity).presence
    end

    def isdn
      #  str(1)  object has isdn access, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_isdn) ? 'Y' : 'N'
    end

    def wheelchair_accessible
      # str(1)  object has wheelchair access, (definition found under www.procap.ch), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_wheelchair_accessible) ? 'Y' : 'N'
    end

    def animal_allowed
      #  str(1)  animal allowed in object, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      # AM: obsolete
    end

    def ramp
      #  str(1)  object has ramp, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_ramp) ? 'Y' : 'N'
    end

    def lifting_platform
      #  str(1)  object has lifting platform, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_lifting_platform) ? 'Y' : 'N'
    end

    def railway_terminal
      #  str(1)  object has railway terminal, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_railway_terminal) ? 'Y' : 'N'
    end

    def restrooms
      # str(1)  object has restrooms, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:number_of_restrooms).presence.to_i > 0 ? 'Y' : 'N'
    end

    def water_supply
      #  str(1)  object has water supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_water_supply) ? 'Y' : 'N'
    end

    def sewage_supply
      # str(1)  object has water sewage supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_sewage_supply) ? 'Y' : 'N'
    end

    def power_supply
      #  str(1)  object has power supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      # AM: obsolete
    end

    def gas_supply
      #  str(1)  object has gas supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      # AM: obsolete
    end

    def municipal_info
      #  str(1)  not used
    end

    def own_object_url
      #  str(100)  e.g.: http://www.homegate.ch/id=d,100081149,mieten oder kaufen  d=german, f=french, i=italian, e=english
    end

    def billing_anrede
      #  int(1)  Gender: 1=Female, 2=Male, 3=Company
    end

    def billing_first_name
      #  str(200)  First name on billing address
    end

    def billing_name
      #  str(200)  Name on billing address
    end

    def billing_company
      # str(200)  Company on billing address
    end

    def billing_street
      #  str(200)  Street of billing adress
    end

    def billing_post_box
      #  str(200)  Additional streetfield for billing address
    end

    def billing_zip
      # str(10) ZIP code  for billing address
    end

    def billing_place_name
      #  str(200)  City name  for billing address
    end

    def billing_land
      #  str(200)  Country  for billing address (default/empty = Switzerland)
    end

    def billing_phone_1
      # str(200)  Phone number for billing address
    end

    def billing_phone_2
      # str(200)  Additional phone number for billing address
    end

    def billing_mobile
      #  str(200)  Mobile phone number for billing address
    end

    def billing_language
      #  int(1)  Billing Language: 1=German, 2=French, 3=Italian, 4=English
    end

    def publishing_id
      # int(10) Code for selecting publishing of advertisement
    end

    def delivery_id
      # int(10) Code for selecting delivery of advertisement
    end

    def commission_sharing
      #  int(1)  not used
    end

    def commission_own
      #  str(10) not used
    end

    def commission_partner
      #  str(10) not used
    end

    def agency_logo_2
      # str(200)  not used
    end

    def number_of_floors
      #  int(2)  number of floors in object itself
      model.try(:figure).try(:floors).presence
    end

    def year_renovated
      #  int(4)  year of last renovation job on object
      model.try(:figure).try(:renovated_on).presence
    end

    def flat_sharing_community
      #  str(1)  aparment has to be shared with a roommate,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def corner_house
      #  str(1)  house is the last one in a row of multiple houses, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:building_type).presence == RealEstate::BUILDING_CORNER_HOUSE ? 'Y' : 'N'
    end

    def middle_house
      #  str(1)  house is the middle one in a row of multiple houses, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:building_type).presence == RealEstate::BUILDING_MIDDLE_HOUSE ? 'Y' : 'N'
    end

    def building_land_connected
      # str(1)  parcel included, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_developed) ? 'Y' : 'N'
    end

    def gardenhouse
      # str(1)  garden has house included, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def raised_ground_floor
      # str(1)  1st level is not pavement even, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_raised_ground_floor) ? 'Y' : 'N'
    end

    def new_building
      #  str(1)  object has been built in this year,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_new_building) ? 'Y' : 'N'
    end

    def old_building
      #  str(1)  object has at least 50 years,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_old_building) ? 'Y' : 'N'
    end

    def under_building_laws
      # str(1)  land area is not included in offer_type, has to be rented separately,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_under_building_laws) ? 'Y' : 'N'
    end

    def under_roof
      #  str(1)  object is under a roof,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:infrastructure).try(:has_roofed_parking_spot) ? 'Y' : 'N'
    end

    def swimmingpool
      #  str(1)  a swimmingpool is included with this object,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:has_swimming_pool) ? 'Y' : 'N'
    end

    def minergie_general
      #  str(1)  object has been built along minergie standards,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_minergie_style) ? 'Y' : 'N'
    end

    def minergie_certified
      #  str(1)  object has been certified by minergie,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
      model.try(:information).try(:is_minergie_certified) ? 'Y' : 'N'
    end

    def last_modified
      # datetime  date of last modification of this record - format: DD.MM.YYYY HH24:mm:ss (24h time format) ex: 04.07.2007 13:42:37
      model.updated_at.strftime("%d.%m.%Y %H:%M:%S") if model.updated_at.present?
    end

    def advertisement_id
      #  str(200)  Advertisement ID given to the ad by homegate AG at time of publication
    end

    def sparefield_1
      #  - for future use
    end

    def sparefield_2
      #  - for future use
    end

    def sparefield_3
      #  - for future use
    end

    def sparefield_4
      #  - for future use
    end

    def to_a
      allowed.map { |key| send key }
    end


    private
    def top_level_category_name
      model.top_level_category.try(:name)
    end

    def category_name
      model.category.name
    end

  end
end
