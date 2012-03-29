class NewsItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  PER_PAGE = 10

  field :title, :type => String
  field :teaser, :type => String
  field :content, :type => String
  field :date, :type => Date
  field :locale, :type => String, :defaults => 'de'

  validates :title, :teaser, :content, :date, :presence => true
end