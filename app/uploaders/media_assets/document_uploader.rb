module MediaAssets
  class DocumentUploader < CarrierWave::Uploader::Base
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

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_white_list
      ExtensionWhiteList.new %w(pdf)
    end

  end
end