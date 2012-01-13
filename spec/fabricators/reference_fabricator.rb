# use Fabricate.build :reference and assign real_estate manually
Fabricator(:reference) do
  property_key { "Property Key #{Fabricate.sequence}" }
  building_key { "Building Key #{Fabricate.sequence}" }
  unit_key { "Unit Key #{Fabricate.sequence}" }
  #real_estate #crazy shit: r = Fabricate :real_estate, :reference=>Fabricate(:reference), now we have 2!! RealEstate Objects created, both referencing the same embedded Reference-Document
end