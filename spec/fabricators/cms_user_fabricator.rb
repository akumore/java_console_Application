Fabricator(:cms_user, :from => 'Cms::User') do
  email { "test#{Fabricate.sequence}@test.com" }
  password '123456'
end
