class HomepageController < ApplicationController

  def index
    @projects_for_sale = ReferenceProjectDecorator.decorate ReferenceProject.for_sale.where(:locale => I18n.locale)
    @projects_for_rent = ReferenceProjectDecorator.decorate ReferenceProject.for_rent.where(:locale => I18n.locale)
  end

end
