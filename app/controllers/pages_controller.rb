class PagesController < ApplicationController
  respond_to :html

  rescue_from Mongoid::Errors::DocumentNotFound do |err|
    logger.warn [err.class, err].join(": ")
    redirect_to root_path
  end

  def show
    @page = Page.where(query_params).first or raise Mongoid::Errors::DocumentNotFound.new(Page, query_params)
    respond_with @page
  end

  private

  def query_params
    { name: params[:name], locale: I18n.locale }
  end
end
