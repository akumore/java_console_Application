class Cms::SecuredController < ActionController::Base
  protect_from_forgery
  layout 'cms/application'
  respond_to :html

  before_filter :authenticate_user!

end