class Cms::SecuredController < ApplicationController
  before_filter :authenticate_user!
  layout 'cms/application'
end