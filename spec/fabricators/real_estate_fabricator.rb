Fabricator(:real_estate) do
  state RealEstate::STATE_EDITING
  utilization RealEstate::UTILIZATION_PRIVATE
  offer RealEstate::OFFER_FOR_RENT
  channels { [RealEstate::WEBSITE_CHANNEL] }
  title { "A fine real estate property #{Fabricate.sequence}" }
  description 'Some real estate description...'
  utilization_description 'Commercial, Restaurant'
  office { Fabricate(:office) }
end

Fabricator(:published_real_estate, :from => :real_estate) do
  state RealEstate::STATE_PUBLISHED
end

Fabricator(:residential_building, :from => :real_estate) do
  category { Fabricate(:category) }
  offer RealEstate::OFFER_FOR_RENT
  utilization RealEstate::UTILIZATION_PRIVATE
  state RealEstate::STATE_PUBLISHED
  channels [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
end

Fabricator(:commercial_building, :from => :real_estate) do
  category { Fabricate(:category) }
  offer RealEstate::OFFER_FOR_RENT
  utilization RealEstate::UTILIZATION_COMMERICAL
  state RealEstate::STATE_PUBLISHED
  channels [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
end
