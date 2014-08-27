Fabricator(:real_estate) do
  state RealEstate::STATE_EDITING
  utilization Utilization::LIVING
  offer Offer::RENT
  channels { [RealEstate::WEBSITE_CHANNEL] }
  title { "A fine real estate property #{Fabricate.sequence}" }
  description 'Some real estate description...'
  utilization_description 'Commercial, Restaurant'
  office { Fabricate(:office) }

  after_build do |re|
    field_access = re.field_access
    if info = re.information
      info.decorate(context: {field_access: field_access}).update_characteristics
    end
    if figure = re.figure
      figure.decorate(context: {field_access: field_access}).update_characteristics
    end
  end
end

Fabricator(:published_real_estate, :from => :real_estate) do
  state RealEstate::STATE_PUBLISHED
end

Fabricator(:residential_building, :from => :real_estate) do
  category { Fabricate(:category) }
  offer Offer::RENT
  utilization Utilization::LIVING
  state RealEstate::STATE_PUBLISHED
  channels [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
end

Fabricator(:commercial_building, :from => :real_estate) do
  category { Fabricate(:category) }
  offer Offer::RENT
  utilization Utilization::WORKING
  state RealEstate::STATE_PUBLISHED
  channels [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL]
end
