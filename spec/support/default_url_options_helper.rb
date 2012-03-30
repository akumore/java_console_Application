module DefaultUrlOptionsHelper
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