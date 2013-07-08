Fabricator(:microsite_reference) do
  property_key { "Property Key #{Fabricate.sequence}" }
  building_key { "Building Key #{Fabricate.sequence}" }
end
