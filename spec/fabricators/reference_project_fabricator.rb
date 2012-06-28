Fabricator(:reference_project) do
  title { "A fine reference project #{Fabricate.sequence}" }
  description 'Some reference project description...'
  offer RealEstate::OFFER_FOR_RENT
  image File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  locale :de
  position Fabricate.sequence
end

