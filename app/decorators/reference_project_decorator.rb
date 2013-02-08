class ReferenceProjectDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :reference_project
  decorates :gallery_photo
  decorates_association :real_estate

  def is_wide_content?
    if model.has_attribute?(:descirption)
      description.present? && description.length > 150
    end
  end

  def title
    truncate(model.title, :length => 40)
  end
end
