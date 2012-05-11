Fabricator(:address) do
  street 'Bahnhofstrasse'
  street_number { Fabricate.sequence }
  city 'Adliswil'
  zip '9120'
  canton 'zh'
  link_url 'http://www.alfred-mueller.ch'
end
