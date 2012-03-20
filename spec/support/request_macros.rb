module RequestMacros
  def login_cms_user
    before(:each) do
      @cms_user = Fabricate(:cms_admin)
      visit new_user_session_path
      within "#user_new" do
        fill_in "E-Mail", :with => @cms_user.email
        fill_in "Passwort", :with => '123456'
        click_on "Sign in"
      end
    end
  end

  alias :login_cms_admin :login_cms_user

  def login_cms_editor
    before(:each) do
      @cms_user = Fabricate(:cms_editor)
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

  def monkey_patch_default_url_options
    before(:all) do
      ActionView::TestCase::TestController.class_eval do
        alias_method_chain :default_url_options, :locale
      end
      ActionDispatch::Routing::RouteSet.class_eval do
        alias_method_chain :default_url_options, :locale
      end
    end

    after(:all) do
      ActionView::TestCase::TestController.class_eval do
        alias_method :default_url_options, :default_url_options_without_locale
      end
      ActionDispatch::Routing::RouteSet.class_eval do
        alias_method :default_url_options, :default_url_options_without_locale
      end
    end
  end

end
