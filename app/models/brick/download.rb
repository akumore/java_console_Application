class Brick::Download < Brick::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :file, type: String

  validates :title, presence: true

  mount_uploader :file, DownloadBrickDocumentUploader
  mount_uploader :image, DownloadBrickImageUploader
end
