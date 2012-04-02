class Cms::SecuredController < ActionController::Base
  protect_from_forgery
  layout 'cms/application'
  respond_to :html
  helper_method :content_locale
  before_filter :authenticate_user!

  private

  def content_locale
    params[:content_locale].presence || I18n.default_locale
  end
end