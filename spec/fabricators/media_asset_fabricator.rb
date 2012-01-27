Fabricator(:media_asset_image, :class_name => 'MediaAsset') do
  media_type "image"
  is_primary false
  file File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  title "Image title"
end

Fabricator(:media_asset_video, :class_name => 'MediaAsset') do
  media_type "video"
  is_primary false
  file File.open("#{Rails.root}/spec/support/test_files/video.mp4")
  title "Video title"
end

Fabricator(:media_asset_document, :class_name => 'MediaAsset') do
  media_type "document"
  is_primary false
  file File.open("#{Rails.root}/spec/support/test_files/document.pdf")
  title "Document title"
end