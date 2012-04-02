Fabricator(:news_item) do
  title { sequence(:title) { |n| "News Title #{n}" } }
  teaser "News Teaser shown in Page Footer"
  content "News Content News Content News Content"
  date Date.today
  locale :de
end