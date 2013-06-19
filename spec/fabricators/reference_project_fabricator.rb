Fabricator(:reference_project) do
  title { "A fine reference project #{Fabricate.sequence}" }
  displayed_on { [ReferenceProject::HOME_AND_OFFER_PAGE] }
  description 'Some reference project description...'
  offer Offer::RENT
  section ReferenceProjectSection::RESIDENTIAL_BUILDING
  images { [Fabricate.build(:reference_project_image)] }
  locale :de
  position Fabricate.sequence
end

Fabricator(:reference_project_for_sale, :from => :reference_project) do
  offer Offer::SALE
end

Fabricator(:reference_project_for_rent, :from => :reference_project) do
  offer Offer::RENT
end

