class DownloadBrickImageUploader < BaseUploader

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    ExtensionWhiteList.new %w(jpeg jpg png)
  end
end
