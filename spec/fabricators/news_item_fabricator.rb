Fabricator(:news_item) do
  title { sequence(:title) { |n| "News Title #{n}" } }
  content "News Content News Content News Content"
  date Date.today
  published true
  locale :de
end
