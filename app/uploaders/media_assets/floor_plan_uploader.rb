require 'carrierwave/processing/mime_types'

module MediaAssets
  class FloorPlanUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

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

    version :minidoku do
      process :convert => 'jpg'
      process :resize_to_fill => [2000, 1000]
    end

    version :gallery, :from_version => :minidoku do
      process :resize_to_fill => [1000, 500]
      process :quality => 80
    end

    version :thumb, :from_version => :gallery do
      process :resize_to_fill => [145, 88]
    end

    version :cms_preview, :from_version => :gallery do
      process :resize_to_fill => [600, 340]
    end

    def filename
      super.chomp(File.extname(super)) + '.jpg' if super
    end

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_white_list
      ExtensionWhiteList.new %w(jpg jpeg png)
    end

  end
end