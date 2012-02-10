# encoding: utf-8

Fabricator(:category) do
	label { "Category #{Fabricate.sequence}" }
	name { |category| category.label.downcase.parameterize }
end

%w(house properties apartment).each do |category_name|
  Fabricator("#{category_name}_category".to_sym, :from => :category) do
    label 'Subkategorie'
    name 'subcategory'
    parent { Fabricate(:category, :label => category_name.upcase, :name => category_name) }
  end
end
