Fabricator(:pricing) do
  for_rent_netto 1520
  for_rent_extra 100
  for_sale 1300000
  price_unit "month"
  inside_parking 140
  outside_parking 120
  inside_parking_temporary 80
  outside_parking_temporary 65
  storage 1600
  extra_storage 120
  estimate '1700 - 2600.-'
end

Fabricator(:pricing_for_rent, :class_name => :pricing) do
  for_rent_netto 1999
  for_rent_extra 99
  price_unit "month"
end

Fabricator(:pricing_for_sale, :class_name => :pricing) do
  for_sale 1300000
end