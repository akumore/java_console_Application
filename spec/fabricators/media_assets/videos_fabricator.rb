Fabricator :media_assets_video, :class_name => MediaAssets::Video do
  title "Image title"
  file File.open("#{Rails.root}/spec/support/test_files/video.mp4")
end