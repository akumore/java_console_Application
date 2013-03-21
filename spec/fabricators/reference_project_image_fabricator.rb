Fabricator(:reference_project_image) do
  image { File.open("#{Rails.root}/spec/support/test_files/image.jpg") }
end
