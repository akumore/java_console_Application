class MediaAsset
  
  include Mongoid::Document
  include Mongoid::Timestamps

  IMAGE = 'image'
  IMAGE_360 = 'image360'
  VIDEO = 'video'
  DOCUMENT = 'document'

  embedded_in :real_estate

  scope :images, where(:media_type => MediaAsset::IMAGE)
  scope :videos, where(:media_type => MediaAsset::VIDEO)
  scope :docs, where(:media_type => MediaAsset::DOCUMENT)
  
  scope :primary, where(:is_primary=>true)
  scope :displayable, any_of(
    { :media_type => MediaAsset::IMAGE }, 
    { :media_type => MediaAsset::VIDEO }
  )
  scope :floorplans, where(:media_type => MediaAsset::IMAGE, :is_floorplan => true)

  mount_uploader :file, MediaAssetUploader

  field :media_type, :type => String
  field :is_primary, :type => Boolean
  field :is_floorplan, :type => Boolean
  field :title, :type => String
  field :file, :type => String

  validates :title, :presence => true
  validates :media_type, :presence => true

  delegate :url, :to=>:file

  def image?
    media_type == MediaAsset::IMAGE
  end

  def video?
    media_type == MediaAsset::VIDEO
  end

  def document?
    media_type == MediaAsset::DOCUMENT
  end

  def is_floorplan?
    image? && is_floorplan
  end
end
