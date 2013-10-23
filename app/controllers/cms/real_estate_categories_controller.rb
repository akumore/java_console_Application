class Cms::RealEstateCategoriesController < ApplicationController
  def index
    @categories = Category.unscoped.where(utilization: params[:utilization]).sorted_by_utilization
    @category = @categories.first
    respond_to do |format|
      format.js
    end
  end
end
