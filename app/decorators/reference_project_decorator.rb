class ReferenceProjectDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :reference_project
  decorates :gallery_photo
  decorates_association :real_estate

  def is_wide_content?
    description.present? && description.length > 150
  end

  def title
    truncate(model.title, :length => 40)
  end

  def gallery_photo?
    model.instance_of?(GalleryPhoto)
  end
end
