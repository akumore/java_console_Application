class Cms::RealEstateUtilizationsController < ApplicationController
  def index
    @categories = Category.where(utilization: params[:utilization])

    respond_to do |format|
      format.js
    end
  end
end
