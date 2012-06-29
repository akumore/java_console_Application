module PagesHelper

  def reference_projects
    ReferenceProject.where(:locale => I18n.locale)
  end

end
