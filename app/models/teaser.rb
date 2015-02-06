class Teaser
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :brick_teasers

  field :title, :type => String
  field :link, :type => String
  field :href, :type => String
  field :locale, type: String, default: :de

  validates :title, presence: true
  validates :link, presence: true
  validates :href, presence: true
end
