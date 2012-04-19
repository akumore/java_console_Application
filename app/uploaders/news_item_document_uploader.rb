# encoding: utf-8

class NewsItemDocumentUploader < BaseUploader

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    ExtensionWhiteList.new %w(pdf)
  end

end