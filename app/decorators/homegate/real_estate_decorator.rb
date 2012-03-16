modudef le Homegate
  class RealEstateDecorator

    def version
      #str(50) IDX3.01
    end

    def sender_id
      # str(50) Name of the used tool and export versionnumber (eg. Sigmasoft_v2.11, excelsior 21.23, immotools v1.99 ...)
    end
    
    def object_category
      # str(25) APPT','HOUSE','INDUS','PROP','GASTRO','AGRI','PARK','GARDEN','SECONDARY' (see list on tab "ObjectCategory")
    end
    
    def object_type
      # int(3)  see list on tab "ObjectCategory"
    end
    
    def offer_type
      #  str(200)  RENT','SALE'
    end
    
    def ref_property
      #  str(80) at least one of the refs must be non blank (the word null as a value in ref_object cannot be used)
    end
    
    def ref_house
      # str(80) the word null as a value in ref_house cannot be used
    end
    
    def ref_object
      #  str(80) the word null as a value in ref_object cannot be used
    end
    
    def object_street
      # str(200)  must field (exact match of street and number) for the geographical search on map.homegate.ch
    end

    def object_zip
      # str(10) If country CH must be a valid 4 digit code (http://www.post.ch). If blank zip code and not in country CH then allow zip code with constant 'nozip'
    end

    def object_city
      # str(200)  
    end

    def object_state
      #  str(2)  ZH, AG etc.
    end

    def object_country
      #  str(2)  A2 ISO codes <http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html>
    end

    def region
      #  str(200)  not used
    end

    def object_situation
      #  str(50) remarkable situation within the city or town. eg: 'centre ville'
    end

    def available_from
      #  date  if empty="on request" / Date (DD.MM.YYYY)=Date / Date in past or current date=immediately
    end

    def object_title
      #  str(70) eyecatcher, title of advertisement
    end

    def object_description
      #  str(4000) biggest varchar2(4000) in oracle - split description into two parts if required. The following HTML-Tags can be used: <LI>,</LI>,<BR>, <B>,</B>. All other Tags will be removed.
    end

    def selling_price
      # int(10) round up / selling_price OR rent_net  is mandatory / empty="by request" - if offer_type = RENT: total rent price - if offer_type = SALE: total sellingprice
    end

    def rent_net
      #  int(10) round up / selling_price OR rent_net  is mandatory / empty="by request"
    end

    def rent_extra
      #  int(10) round up
    end

    def price_unit
      #  str(10) SELL','SELLM2','YEARLY','M2YEARLY','MONTHLY','WEEKLY','DAILY' (related to field offer_type)
    end

    def currency
      #  str(3)  (alpha ISO codes <http://www.xe.com/iso4217.htm>)
    end

    def gross_premium
      # str(19) 2-3','3-4','4-5','5-6','6-7','7-8','8+' (in %) (offer_type=SALE & Category=HOUSE & Type=7 only)
    end

    def floor
      # int(6)  floor filter see on tab "Floor filter"
    end

    def number_of_rooms
      # int(5,1)  number of rooms in object itself
    end

    def number_of_apartments
      #  int(5,1)  number of appartments in object itself
    end

    def surface_living
      #  int(10) remove any non-digits
    end

    def surface_property
      #  int(10) remove any non-digits
    end

    def surface_usable
      #  int(10) remove any non-digits
    end

    def volume
      #  int(10) remove any non-digits
    end

    def year_built
      #  int(4)  year object has been built, a.e. 1975
    end

    def prop_view
      # str(1)  object has view, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_fireplace
      #  str(1)  object has fireplace, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_cabletv
      #  str(1)  object has cable tv connection, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_elevator
      # str(1)  object has elevator, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_child_friendly
      # actual key: prop_child-friendly (with dash)
      # str(1)  object is locarted child friendly, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_parking
      #  str(1)  object has parking lot, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_garage
      # str(1)  object has garage place, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_balcony
      #  str(1)  object has balcony, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def prop_roof_floor
      # str(1)  not used
    end

    def distance_public_transport
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def distance_shop
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def distance_kindergarten
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def distance_school1
      #  int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def distance_school2
      #  int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def picture_1_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_2_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_3_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_4_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_5_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_1_title
      # str(200)  title of picture
    end

    def picture_2_title
      # str(200)  title of picture
    end

    def picture_3_title
      # str(200)  title of picture
    end

    def picture_4_title
      # str(200)  title of picture
    end

    def picture_5_title
      # str(200)  title of picture
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

    def movie_filename
      #  str(200)  filename without path, eg: 'movie.avi' - valid movie types = mov, avi, rpm, mpeg, mpg, wmv, mp4, flv (movies must be transfered in directory "movies")
    end

    def movie_title
      # str(200)  title of movie
    end

    def movie_description
      # str(1800) not used
    end

    def document_filename
      # str(200)  filename w/o path, eg: 'doc.pdf' - valid document types = pdf/rtf/doc (docs must be transfered in directory "docs")
    end

    def document_title
      #  str(200)  title of document
    end

    def document_description
      #  str(1800) not used
    end

    def url
      # str(200)  only displayed if different to agency URL and if object contains more than 4 pictures - Product ImmoViewer = URL must start with "http://www.immoviewer.ch/"
    end

    def agency_id
      # str(10) given by homegate (Info: agency_id + ref_property + ref_object + ref_house forms the unique object key)
    end

    def agency_name
      # str(200)  
    end

    def agency_name_2
      # str(255)  
    end

    def agency_reference
      #  str(200)  (real estate contact person)
    end

    def agency_street
      # str(200)  
    end

    def agency_zip
      #  str(200)  blank allowed for pool agencies
    end

    def agency_city
      # str(200)  
    end

    def agency_country
      #  str(2)  A2 ISO codes <http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html> - if blank then default to 'CH'
    end

    def agency_phone
      #  str(200)  
    end

    def agency_mobile
      # str(200)  not used
    end

    def agency_fax
      #  str(200)  
    end

    def agency_email
      #  str(200)  if empty=default e-mailadress of agency will be used - if filled=e-mail will be used for this record only
    end

    def agency_logo
      # str(200)  not used - default of agency will be used or http://www.homegate.ch/neutral/img/logos/l_xxx.gif
    end

    def visit_name
      #  str(200)  Contact person to visit the object
    end

    def visit_phone
      # str(200)  Contact person phone number (mobile number or fix number)
    end

    def visit_email
      # str(200)  not used
    end

    def visit_remark
      #  str(200)  Contact Person comment e.g. object can be visited on Monday from 5-7p.m.
    end

    def publish_until
      # date  not used
    end

    def destination
      # str(200)  not used
    end

    def picture_6_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_7_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_8_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_9_filename
      #  str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_6_title
      # str(200)  title of picture
    end

    def picture_7_title
      # str(200)  title of picture
    end

    def picture_8_title
      # str(200)  title of picture
    end

    def picture_9_title
      # str(200)  title of picture
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

    def distance_motorway
      # int(5)  in meter - remove any non digits (1min. walk = 50m)
    end

    def ceiling_height
      #  int(10,2) height of room in meters
    end

    def hall_height
      # int(10,2) height of hall in meters
    end

    def maximal_floor_loading
      # int(10,1) kg/m2
    end

    def carrying_capacity_crane
      # int(10,1) kg
    end

    def carrying_capacity_elevator
      #  int(10,1) kg
    end

    def isdn
      #  str(1)  object has isdn access, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def wheelchair_accessible
      # str(1)  object has wheelchair access, (definition found under www.procap.ch), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def animal_allowed
      #  str(1)  animal allowed in object, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def ramp
      #  str(1)  object has ramp, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def lifting_platform
      #  str(1)  object has lifting platform, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def railway_terminal
      #  str(1)  object has railway terminal, ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def restrooms
      # str(1)  object has restrooms, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def water_supply
      #  str(1)  object has water supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def sewage_supply
      # str(1)  object has water sewage supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def power_supply
      #  str(1)  object has power supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def gas_supply
      #  str(1)  object has gas supply, (not neccessary for HOUSE/APPT), ''N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
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

    def picture_10_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_11_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_12_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_13_filename
      # str(200)  filename without path, eg: 'pic.jpg' - valid picture types = jpg/jpeg/gif (pictures must be transfered in directory "images")
    end

    def picture_10_title
      #  str(200)  title of picture
    end

    def picture_11_title
      #  str(200)  title of picture
    end

    def picture_12_title
      #  str(200)  title of picture
    end

    def picture_13_title
      #  str(200)  title of picture
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
    end

    def year_renovated
      #  int(4)  year of last renovation job on object
    end

    def flat_sharing_community
      #  str(1)  aparment has to be shared with a roommate,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def corner_house
      #  str(1)  house is the last one in a row of multiple houses, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def middle_house
      #  str(1)  house is the middle one in a row of multiple houses, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def building_land_connected
      # str(1)  parcel included, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def gardenhouse
      # str(1)  garden has house included, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def raised_ground_floor
      # str(1)  1st level is not pavement even, 'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def new_building
      #  str(1)  object has been built in this year,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def old_building
      #  str(1)  object has at least 50 years,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def under_building_laws
      # str(1)  land area is not included in offer_type, has to be rented separately,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def under_roof
      #  str(1)  object is under a roof,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def swimmingpool
      #  str(1)  a swimmingpool is included with this object,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def minergie_general
      #  str(1)  object has been built along minergie standards,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def minergie_certified
      #  str(1)  object has been certified by minergie,  'N','Y' or blank (blank=the same meaning as 'N'); '0', '1' or blank (blank=the same meening as '0')
    end

    def last_modified
      # datetime  date of last modification of this record - format: DD.MM.YYYY HH24:mm:ss (24h time format) ex: 04.07.2007 13:42:37
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
    
  end
end