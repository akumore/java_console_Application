class NewsItemImage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :news_item, :inverse_of=>:images
  default_scope asc(:position)

  mount_uploader :file,  NewsItemImageUploader

  field :file, :type=>String
  field :position, :type=>Integer

  before_create :setup_position

  private
  def setup_position
    self.position = news_item.images.max(:position) + 1
  end

end