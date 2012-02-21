Fabricator(:job_application) do
  firstname 'Hermann'
  lastname 'Hesse'
  birthdate '19.2.1859'
  street 'Via Montagna'
  city 'Montagnola'
  zipcode '9223'
  phone '093 299 30 10'
  mobile '050 234 33 33'
  email 'hh@montagnola.ch'
  attachment File.open("#{Rails.root}/spec/support/test_files/document.pdf")
end
