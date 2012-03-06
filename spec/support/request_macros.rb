module RequestMacros
  def login_cms_user
    before(:each) do
      @cms_user = Fabricate(:cms_user)
      visit new_user_session_path
      within "#user_new" do
        fill_in "E-Mail", :with => @cms_user.email
        fill_in "Passwort", :with => '123456'
        click_on "Sign in"
      end
    end
  end

  def create_category_tree
    before :each do
      parent_category = Fabricate(:category,
                                :name => 'parent_category',
                                :label => 'Parent Category'
    )

    Fabricate(:category,
              :name => 'child_category_1',
              :label => 'Child Category 1',
              :parent => parent_category
    )

    Fabricate(:category,
              :name => 'child_category_2',
              :label => 'Child Category 2',
              :parent => parent_category
    )
    end
  end
end
