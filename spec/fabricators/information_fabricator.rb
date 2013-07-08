# encoding: utf-8
Fabricator(:information) do
  available_from { Date.parse('2012-01-01') }
  additional_information 'Ergänzende Informationen zum Ausbau'
end
