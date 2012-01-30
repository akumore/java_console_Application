class Cms::SecuredController < ApplicationController
  before_filter :authenticate_user!
  before_filter :print_request_format
  layout 'cms/application'
  respond_to :html

  def print_request_format
    puts request.formats.inspect.to_s
  end
end