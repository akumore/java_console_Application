# encoding: utf-8

Fabricator(:appointment, :from => :appointment) do
  firstname 'Hans'
  lastname 'Muster'
  email 'hans.muster@test.ch'
  phone '041 123 23 45'
  street 'Musterstrasse 12'
  zipcode '8312'
  city 'Musterhausen'
end
