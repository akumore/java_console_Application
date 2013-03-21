module ReferenceProjectSection

  RESIDENTIAL_BUILDING = 'residetal_building'
  BUSINESS_BUILDING = 'business_building'
  PUBLIC_BUILDING = 'public_building'
  REBUILDING = 'rebuilding'

  def self.all
    [RESIDENTIAL_BUILDING, BUSINESS_BUILDING, PUBLIC_BUILDING, REBUILDING]
  end

  module Accessors
    def residential_building?
      section == RESIDENTIAL_BUILDING
    end

    def business_building?
      section == BUSINESS_BUILDING
    end

    def public_building?
      section == PUBLIC_BUILDING
    end

    def rebuilding?
      section == REBUILDING
    end
  end
end
