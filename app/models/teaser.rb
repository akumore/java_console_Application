class Teaser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :link, type: String
  field :href, type: String
  field :locale, type: String, default: :de

  validates :title, presence: true
  validates :link, presence: true
  validates :href, presence: true

  scope :with_current_locale, -> { where(locale: I18n.locale.to_s) }
end
