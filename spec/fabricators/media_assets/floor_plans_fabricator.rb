Fabricator :media_assets_floor_plan, :class_name => MediaAssets::FloorPlan do
  title "Floor plan title"
  file File.open("#{Rails.root}/spec/support/test_files/image.jpg")
end
