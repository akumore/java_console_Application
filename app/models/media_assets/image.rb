module MediaAssets
  class Image < ImageBase
    mount_uploader :file, MediaAssets::ImageUploader

    field :is_primary, :type => Boolean, :default => false

    scope :primaries, :where => {:is_primary => true}
    scope :for_print, :where => {:is_primary => false}

    def self.primary
      primaries.first || MediaAssets::Image.new
    end

    private
    def setup_position
      self.position ||= real_estate.images.max(:position).to_i + 1
    end

  end
end
