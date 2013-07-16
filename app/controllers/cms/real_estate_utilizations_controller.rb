class Cms::RealEstateUtilizationsController < ApplicationController
  def index
    @categories = Category.unscoped.where(utilization: params[:utilization]).sorted_by_utilization

    respond_to do |format|
      format.js
    end
  end
end
