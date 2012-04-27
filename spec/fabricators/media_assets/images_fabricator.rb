Fabricator :media_assets_image, :class_name => MediaAssets::Image do
  title "Image title"
  is_primary false
  file File.open("#{Rails.root}/spec/support/test_files/image.jpg")
end