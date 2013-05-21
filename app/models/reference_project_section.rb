module ReferenceProjectSection

  RESIDENTIAL_BUILDING = 'residential_building'
  RESIDENTIAL_COMMERCIAL_BUILDING = 'residential_commercial_building'
  BUSINESS_BUILDING = 'business_building'
  TRADE_INDUSTRIAL_BUILDING = 'trade_industrial_building'
  SPECIAL_BUILDING = 'special_building'
  REBUILDING = 'rebuilding'

  def self.all
    [RESIDENTIAL_BUILDING, RESIDENTIAL_COMMERCIAL_BUILDING, BUSINESS_BUILDING, TRADE_INDUSTRIAL_BUILDING, SPECIAL_BUILDING, REBUILDING]
  end

  module Accessors
    def residential_building?
      section == RESIDENTIAL_BUILDING
    end

    def residential_commercial_building?
      section == RESIDENTIAL_COMMERCIAL_BUILDING
    end

    def business_building?
      section == BUSINESS_BUILDING
    end

    def trade_industrial_building?
      section == TRADE_INDUSTRIAL_BUILDING
    end

    def special_building?
      section == SPECIAL_BUILDING
    end

    def rebuilding?
      section == REBUILDING
    end
  end
end
