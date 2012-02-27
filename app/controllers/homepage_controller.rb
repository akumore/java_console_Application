class HomepageController < ApplicationController

  def index
    @projects_for_rent = RealEstateDecorator.decorate RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_RENT).all
    @projects_for_sale = RealEstateDecorator.decorate RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_SALE).all
    @projects_for_build = RealEstateDecorator.decorate [] #TODO What kind of real estate? Is this something like 'OFFER_FOR_BUILD?'
  end

end