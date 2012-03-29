# encoding: utf-8

class NewsItemImageUploader < BaseUploader

  version :thumb do
    process :resize_to_fill => [100,100]
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

end