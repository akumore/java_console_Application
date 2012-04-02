class NewsItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  embeds_many :images, :class_name=>"NewsItemImage", cascade_callbacks: true

  accepts_nested_attributes_for :documents, :allow_destroy => true, :reject_if => :all_blank
  embeds_many :documents, :class_name=>"NewsItemDocument", cascade_callbacks: true

  PER_PAGE = 10

  field :title, :type => String
  field :teaser, :type => String
  field :content, :type => String
  field :date, :type => Date
  field :locale, :type => String, :default => 'de'

  validates :title, :teaser, :content, :date, :presence => true
end