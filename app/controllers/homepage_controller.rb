class HomepageController < ApplicationController

  def index
    @projects_for_rent = RealEstateDecorator.decorate RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_RENT).all
    @projects_for_sale = RealEstateDecorator.decorate RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_SALE).all
  end

end