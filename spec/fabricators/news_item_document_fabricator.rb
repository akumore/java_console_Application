Fabricator(:news_item_document) do
  file { File.open "#{Rails.root}/spec/support/test_files/document.pdf"}
end