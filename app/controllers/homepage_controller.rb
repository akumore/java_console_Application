class HomepageController < ApplicationController

  def index
    @projects_for_rent = RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_RENT).all
    @projects_for_sale = RealEstate.reference_projects.where(:offer=>RealEstate::OFFER_FOR_SALE).all
    @projects_for_build = [] #TODO What kind of real estate? Is this something like 'OFFER_FOR_BUILD?'
  end

end