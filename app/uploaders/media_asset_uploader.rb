# encoding: utf-8
require 'carrierwave/processing/mime_types'

class MediaAssetUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
     "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  version :minidoku, :if => :is_image? do
    process :convert => 'jpg'
    process :resize_to_fill => [2000, 1000]
  end

  version :gallery, :if => :is_image?, :from_version => :minidoku do
    process :resize_to_fill => [1000, 500]
    process :quality => 80
  end

  version :thumb, :if => :is_image?, :from_version => :gallery do
    process :resize_to_fill => [145, 92]
  end

  version :cms_preview, :if => :is_image?, :from_version => :gallery do
    process :resize_to_fill => [600, 340]
  end

  def filename
    return super unless is_image? self.file
    super.chomp(File.extname(super)) + '.jpg'
  end

  def is_image? image
    %w(image/jpeg image/jpg image/png image/pjpeg).include? image.content_type
  end

  def image_needs_conversion? image
    %w(image/png).include? image.content_type
  end

  def is_video? video
    %w(video/mp4).include? video.content_type
  end

  def is_document? document
    %w(application/pdf).include? document.content_type
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    allowed_types = if model.image?
      %w(jpg jpeg png)
    elsif model.video?
      %w(mp4 m4v mov)
    elsif model.document?
      %w(pdf)
    end

    ExtensionWhiteList.new allowed_types if allowed_types.present?
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
