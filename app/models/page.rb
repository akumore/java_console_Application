class Page

  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :bricks, :class_name => 'Brick::Base'
  accepts_nested_attributes_for :bricks

  field :title, :type => String
  field :name, :type => String
  field :locale, :type => String

  validates :title, :name, :presence => true
  validates :locale, :presence => true, :inclusion => I18n.available_locales.map(&:to_s)
  validates_uniqueness_of :name,  :scope => :locale

end
