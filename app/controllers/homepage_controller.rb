class HomepageController < ApplicationController

  def index
    @projects_for_sale = ReferenceProject.for_sale.where(:locale => I18n.locale)
    @projects_for_rent = ReferenceProject.for_rent.where(:locale => I18n.locale)
  end

end
