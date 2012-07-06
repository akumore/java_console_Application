class ReferenceProjectDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :reference_project
  decorates_association :real_estate

  def is_wide_content?
    description.present? && description.length > 150
  end

end

