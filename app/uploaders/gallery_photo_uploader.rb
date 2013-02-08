# encoding: utf-8

class GalleryPhotoUploader < BaseUploader

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  version :preview do
    process :resize_to_fill => [500,250]
  end

  version :gallery do
    process :resize_to_fill => [1000,500]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end
end
