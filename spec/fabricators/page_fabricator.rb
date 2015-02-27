Fabricator(:page) do
  title 'Seiten Titel'
  name { "seiten-titel-#{Fabricate.sequence}" }
  seo_title 'Page Title'
  seo_description 'SEO description'
  locale :de
end
