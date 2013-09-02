# encoding: utf-8

Fabricator(:category) do
  label { "Category #{Fabricate.sequence}" }
  name { |category| category.label.downcase.parameterize }
  utilization Utilization::LIVING
  sort_order 1
end

%w(house properties apartment).each do |category_name|
  Fabricator("#{category_name}_category".to_sym, :from => :category) do
    label 'Subkategorie'
    name 'subcategory'
    parent { Fabricate(:category, :label => category_name.upcase, :name => category_name) }
  end
end

Fabricator(:row_house_category, :from => :category) do
  label 'Reiheneinfamilienhaus'
  name 'row_house'
  utilization Utilization::LIVING
  parent { Fabricate(:category) }
end

Fabricator(:parking_category, :from => :category) do
  label 'Parkplatz im Freien'
  name 'open_slot'
  utilization Utilization::PARKING
  parent { Fabricate(:category) }
end
