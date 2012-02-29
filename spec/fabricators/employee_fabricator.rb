# encoding: utf-8

Fabricator(:employee) do
  firstname "Max"
  lastname "Muster"
  phone "052 249 39 20"
  mobile "079 469 25 98"
  fax "052 249 22 22"
  email 'max.muster@alfred-mueller.ch'
  image File.open("#{Rails.root}/spec/support/test_files/image.jpg")
  job_function "Mitglied der Geschäftsleitung"
  department Employee::MARKETING_DEPARTMENT
end
