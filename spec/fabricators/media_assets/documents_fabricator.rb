Fabricator :media_assets_document, :class_name => MediaAssets::Document do
  file File.open("#{Rails.root}/spec/support/test_files/document.pdf")
  title "Document title"
end