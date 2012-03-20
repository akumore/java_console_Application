class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale


  protected
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    {:locale => I18n.locale}
  end

  def stored_location_for(resource_or_scope)
    nil
  end

  def after_sign_in_path_for(resource)
    cms_dashboards_path
  end
end
