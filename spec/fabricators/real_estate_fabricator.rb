Fabricator(:real_estate) do
  state RealEstate::STATE_EDITING
  utilization RealEstate::UTILIZATION_PRIVATE
  offer RealEstate::OFFER_FOR_RENT
  channels { [RealEstate::WEBSITE_CHANNEL] }
  title { "A fine real estate property #{Fabricate.sequence}" }
  property_name 'Garden City'
  description 'Some real estate description...'
  short_description 'Some short real estate description...'
  keywords 'Real, Estate, Stuff'
  is_first_marketing true
  utilization_description 'Commercial, Restaurant'
end

Fabricator(:published_real_estate, :from => :real_estate) do
  state RealEstate::STATE_PUBLISHED
end
