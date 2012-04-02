Fabricator(:page) do
  title 'Seiten Titel'
  name { "seiten-titel-#{Fabricate.sequence}" }
  locale :de
end
