class GalleryPhotoDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :gallery_photo

  def is_wide_content?
    false
  end

  def title
    truncate(model.title, :length => 40)
  end
end
