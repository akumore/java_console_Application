module MediaAssets
  class VideoUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    #def default_url
    #  "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    #end

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_white_list
      ExtensionWhiteList.new %w(mp4 m4v mov)
    end

  end
end
