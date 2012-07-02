module PagesHelper

  def reference_projects
    ReferenceProjectDecorator.decorate ReferenceProject.where(:locale => I18n.locale)
  end

  def reference_project_image_caption_div(reference_project, &block)
    attrs  = { :class => [ "image-caption" ] }
    attrs[:class] << 'wide' if reference_project.is_wide_content?
    content_tag :div, attrs do
      capture(&block)
    end
  end
end
