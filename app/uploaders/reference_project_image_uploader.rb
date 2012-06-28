class ReferenceProjectImageUploader < BaseUploader

  version :preview do
    process :resize_to_fill => [250,250]
  end

  version :gallery do
    process :resize_to_fill => [1000,500]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    ExtensionWhiteList.new %w(jpg jpeg png)
  end

end
