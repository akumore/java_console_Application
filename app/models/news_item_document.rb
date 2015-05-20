class NewsItemDocument
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :news_item, inverse_of: :documents
  default_scope asc(:position)

  mount_uploader :file, NewsItemDocumentUploader

  field :file, type: String
  field :position, type: Integer

  before_create :setup_position

  private

  def setup_position
    self.position = news_item.documents.max(:position) + 1
  end
end
