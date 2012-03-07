module ControllerMacros
  def login_cms_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in Fabricate(:cms_user)
    end
  end
end