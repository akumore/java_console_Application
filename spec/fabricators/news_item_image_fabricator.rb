Fabricator(:news_item_image) do
  file { File.open "#{Rails.root}/spec/support/test_files/image.jpg"}
end