module MediaAssets
  class Video < Base
    mount_uploader :file, MediaAssets::VideoUploader


    private
    def setup_position
      self.position ||= real_estate.videos.max(:position) + 1
    end

  end
end
