module MediaAssets
  class ImageBase < Base

    field :image_type, :type => String
    field :crop_x, :type => Integer
    field :crop_y, :type => Integer
    field :crop_w, :type => Integer
    field :crop_h, :type => Integer

    after_update :crop_image

    def original_width
      if file.present?
        MiniMagick::Image.open(file.path)['width']
      end
    end

    def original_height
      if file.present?
        MiniMagick::Image.open(file.path)['height']
      end
    end

    private
    def crop_image
      file.recreate_versions! if crop_x.present?
    end

  end
end
