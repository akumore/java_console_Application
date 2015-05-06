class NewsItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank
  embeds_many :images, class_name: "NewsItemImage", cascade_callbacks: true

  I18n.available_locales.each do |locale|
    accepts_nested_attributes_for :"documents_#{locale}", allow_destroy: true, reject_if: :all_blank
    embeds_many :"documents_#{locale}", class_name: "NewsItemDocument", cascade_callbacks: true
  end

  scope :published, lambda { where(published: true) }

  PER_PAGE = 6

  field :title, type: String, localize: true
  field :content, type: String, localize: true
  field :date, type: Date
  field :locale, type: String, default: 'de'
  field :published, type: Boolean, default: true, localize: true

  validates :title, :content, :date, presence: true

  def documents
    send :"documents_#{I18n.locale}"
  end

  def documents=(*args)
    send :"documents_#{I18n.locale}=", *args
  end
end
