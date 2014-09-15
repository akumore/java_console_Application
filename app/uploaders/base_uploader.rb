require 'carrierwave/processing/mime_types'
require 'extension_white_list'

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::MiniMagick
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  process :set_content_type

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
