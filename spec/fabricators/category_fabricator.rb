Fabricator(:category) do
	label { "Category #{Fabricate.sequence}" }
	name { |category| category.label.downcase.parameterize }
end
