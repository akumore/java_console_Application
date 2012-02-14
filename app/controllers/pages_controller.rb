class PagesController < ApplicationController

  respond_to :html

  def show
    @page = Page.where(:name => params[:name]).first
    respond_with @page
  end
end
