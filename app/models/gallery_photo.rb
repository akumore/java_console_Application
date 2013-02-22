class GalleryPhoto
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope asc(:position)

  mount_uploader :image, GalleryPhotoUploader

  field :title, :type => String
  field :image, :type => String
  field :position, :type => Integer

  validates :title, :image, :presence => true

  before_create :setup_position

  def slider_image
    image
  end

  private
  def setup_position
    self.position = GalleryPhoto.max(:position).to_i + 1
  end
end
