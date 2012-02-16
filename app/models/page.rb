class Page

  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :bricks, :class_name => 'Brick::Base'
  accepts_nested_attributes_for :bricks

  field :title, :type => String
  field :name, :type => String

  validates :title, :presence => true
  validates :name, :uniqueness => true, :presence => true
end
