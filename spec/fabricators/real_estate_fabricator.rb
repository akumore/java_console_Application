Fabricator(:real_estate) do
	state RealEstate::STATE_EDITING
  utilization RealEstate::UTILIZATION_PRIVATE
  offer RealEstate::OFFER_FOR_RENT
  channels { [RealEstate::CHANNELS.first] }
  title 'A fine real estate property'
  property_name 'Garden City'
  description 'Some real estate description...'
  short_description 'Some short real estate description...'
  keywords 'Real, Estate, Stuff'
  is_first_marketing true
  utilization_description 'Commercial, Restaurant'
end
