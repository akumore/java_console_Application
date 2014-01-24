Fabricator(:pricing) do
  available_from { Date.parse('2012-01-01') }
  for_rent_netto 1520
  for_sale 1300000
  additional_costs 100
  price_unit 'monthly'
  inside_parking 140
  outside_parking 120
  double_garage 100
  single_garage 120
  outdoor_bike 130
  covered_bike 140
  covered_slot 150
  storage 1600
  extra_storage 120
end

Fabricator(:pricing_for_rent, :class_name => :pricing) do
  available_from { Date.parse('2012-01-01') }
  for_rent_netto 1999
  additional_costs 99
  price_unit "monthly"
end

Fabricator(:pricing_for_sale, :class_name => :pricing) do
  available_from { Date.parse('2012-01-01') }
  for_sale 1300000
  additional_costs 99
  price_unit 'sell'
end
