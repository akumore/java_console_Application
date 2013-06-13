class HomepageController < ApplicationController

  def index
    @projects_for_sale = ReferenceProjectDecorator.decorate ReferenceProject.displayed_on_home_and_offer_page.for_sale.where(:locale => I18n.locale)
    @projects_for_rent = ReferenceProjectDecorator.decorate ReferenceProject.displayed_on_home_and_offer_page.for_rent.where(:locale => I18n.locale)
    @real_estates = RealEstateDecorator.decorate RealEstate.published.web_channel
  end

end
