class ReferenceProjectSection

  RESIDENTIAL_BUILDING = 'residetal_building'
  BUSINESS_BUILDING = 'business_building'
  PUBLIC_BUILDING = 'public_building'
  REBUILDING = 'rebuilding'

  def self.all
    [RESIDENTIAL_BUILDING, BUSINESS_BUILDING, PUBLIC_BUILDING, REBUILDING]
  end
end
