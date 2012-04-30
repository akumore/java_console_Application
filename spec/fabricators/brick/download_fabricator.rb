Fabricator(:download_brick, :from => :base_brick, :class_name => 'Brick::Download') do
  title "Mein Dokument"
  file File.open("#{Rails.root}/spec/support/test_files/document.pdf")
end
