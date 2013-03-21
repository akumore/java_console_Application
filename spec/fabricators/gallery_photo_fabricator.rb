Fabricator(:gallery_photo) do
  title { "An awesome gallery photos #{Fabricate.sequence}" }
  image File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  position Fabricate.sequence
end
