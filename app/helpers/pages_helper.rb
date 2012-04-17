module PagesHelper
  
  def reference_projects
    RealEstateDecorator.decorate RealEstate.published.reference_projects
  end

end