class Cms::SecuredController < ApplicationController
  before_filter :print_request_format
  before_filter :authenticate_user!
  layout 'cms/application'
  respond_to :html

  def print_request_format
    logger.warn request.formats.inspect.to_s if logger
  end
end