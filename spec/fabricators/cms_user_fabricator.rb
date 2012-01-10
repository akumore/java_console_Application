Fabricate.sequence(:email) { |i| i }

Fabricator(:cms_user, :from => 'Cms::User') do
  email { sequence(:email) { |i| "test#{i}@test.com" } }
end
