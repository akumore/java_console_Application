# encoding: utf-8
require 'carrierwave/processing/mime_types'

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::MiniMagick
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  process :set_content_type

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  #
  # Workaround for empty filename issue
  # https://gist.github.com/519484
  #
  def root
    CarrierWave.root
  end
end
