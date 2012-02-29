Fabricator(:employee) do
  firstname "Max"
  lastname "Muster"
  phone "052 249 39 20"
  mobile "079 469 25 98"
  fax "052 249 22 22"
  image File.open("#{Rails.root}/spec/support/test_files/image.png")
  job_function "Mitglied der Geschäftsleitung"
  department Employee::MARKETING_DEPARTMENT
end
