class Cms::SecuredController < ApplicationController
  before_filter :authenticate_user!
  layout 'cms/application'
  respond_to :html

end