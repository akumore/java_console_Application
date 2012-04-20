# use Fabricate.build :reference and assign real_estate manually

Fabricator(:information) do
  available_from { Date.parse('2012-01-01') }
end
