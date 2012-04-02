Fabricator(:job) do
  title 'Baumeister im Bereich Hochbau'
  text '## Text als Markdown'
  is_published false
  job_profile_file File.open("#{Rails.root}/spec/support/test_files/document.pdf")
  locale 'de'
end

Fabricator(:published_job, :from => :job) do
  is_published true
end
