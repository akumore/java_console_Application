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
      process :crop
      process :convert => 'jpg'
    end

    version :gallery do
      process :crop
      process :convert => 'jpg'
      process :resize_and_pad => [1000, 500, '#FFFFFF']
      process :quality => 80
    end

    version :gallery_zoom do
      process :crop
      process :convert => 'jpg'
      process :resize_to_fit => [1200, 10000]
      process :quality => 80
    end

    version :thumb, :from_version => :gallery do
      process :crop
      process :resize_to_fill => [145, 92]
    end

    def crop
      if model.crop_x.present?
        manipulate! do |img|
          x = model.crop_x.to_i
          y = model.crop_y.to_i
          w = model.crop_w.to_i
          h = model.crop_h.to_i
          img.crop!(x, y, w, h)
        end
      end
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
