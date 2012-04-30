Fabricator(:information) do
  available_from { Date.parse('2012-01-01') }
  notice_dates 'September, Oktober'
  notice_period '3 Monate'
  minimum_rental_period '1 Jahr'
end
