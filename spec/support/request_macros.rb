module RequestMacros
  def login_cms_user
    before(:each) do
      @cms_user = Fabricate(:cms_user)
      visit new_user_session_path
      within "#user_new" do
        fill_in "Email", :with => @cms_user.email
        fill_in "Password", :with => '123456'
        click_on "Sign in"
      end
    end
  end
end
