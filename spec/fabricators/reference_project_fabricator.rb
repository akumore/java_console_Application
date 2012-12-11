Fabricator(:reference_project) do
  title { "A fine reference project #{Fabricate.sequence}" }
  description 'Some reference project description...'
  offer Offer::RENT
  image File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  locale :de
  position Fabricate.sequence
end

Fabricator(:reference_project_for_sale, :from => :reference_project) do
  offer Offer::SALE
end

Fabricator(:reference_project_for_rent, :from => :reference_project) do
  offer Offer::RENT
end

