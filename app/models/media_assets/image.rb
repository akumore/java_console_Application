module MediaAssets
  class Image
    include Mongoid::Document
    include Mongoid::Timestamps

    default_scope asc(:position)
    embedded_in :real_estate

    mount_uploader :file, MediaAssets::ImageUploader

    field :title, :type => String
    field :is_primary, :type => Boolean, :default => false
    field :file, :type => String
    field :position, :type => Integer, :default => 1

    scope :primaries, :where => {:is_primary => true}
    scope :for_print, :where => {:is_primary => false}

    validates :title, :presence => true
    validates_presence_of :file, :if => :new_record?

    before_create :setup_position

    def self.primary
      primaries.first || MediaAssets::Image.new
    end


    private
    def setup_position
      self.position ||= real_estate.images.max(:position) + 1
    end

  end
end