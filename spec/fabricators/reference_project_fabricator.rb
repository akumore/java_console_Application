Fabricator(:reference_project) do
  title { "A fine reference project #{Fabricate.sequence}" }
  description 'Some reference project description...'
  offer RealEstate::OFFER_FOR_RENT
  image File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  locale :de
  position Fabricate.sequence
end

Fabricator(:reference_project_for_sale, :from => :reference_project) do
  offer RealEstate::OFFER_FOR_SALE
end

Fabricator(:reference_project_for_rent, :from => :reference_project) do
  offer RealEstate::OFFER_FOR_RENT
end

