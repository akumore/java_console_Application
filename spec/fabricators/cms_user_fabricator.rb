Fabricator(:cms_user, :from => 'Cms::User') do
  email { "test#{Fabricate.sequence}@test.com" }
  password '123456'
  role 'admin'
end

Fabricator(:cms_editor, :from => :cms_user) do
  role 'editor'
end

Fabricator(:cms_admin, :from => :cms_user) do
  role 'admin'
end