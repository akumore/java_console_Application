module MediaAssets
  class Image < Base
    mount_uploader :file, MediaAssets::ImageUploader

    field :is_primary, :type => Boolean, :default => false
    field :crop_x, :type => Integer
    field :crop_y, :type => Integer
    field :crop_w, :type => Integer
    field :crop_h, :type => Integer

    after_update :crop_image

    scope :primaries, :where => {:is_primary => true}
    scope :for_print, :where => {:is_primary => false}

    def self.primary
      primaries.first || MediaAssets::Image.new
    end

    def original_width
      if file.present?
        f = ::Magick::Image::read(file.path).first
        f.columns
      end
    end

    def original_height
      if file.present?
        f = ::Magick::Image::read(file.path).first
        f.rows
      end
    end


    private
    def setup_position
      self.position ||= real_estate.images.max(:position).to_i + 1
    end

    def crop_image
      file.recreate_versions! if crop_x.present?
    end

  end
end
