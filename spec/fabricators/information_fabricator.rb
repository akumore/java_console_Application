# encoding: utf-8
Fabricator(:information) do
  additional_information 'Ergänzende Informationen zum Ausbau'
  floors 10
  renovated_on 1997
  built_on 1899
  ceiling_height '2.6'
  location_html "Location description"
  interior_html "Interior description"
  infrastructure_html "Infrastructure description"
end
