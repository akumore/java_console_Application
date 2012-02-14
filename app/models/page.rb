class Page

  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :bricks, :class_name => 'Brick::Base'

  field :title, :type => String
  field :name, :type => String

  validates :title, :presence => true
  validates :name, :uniqueness => true, :presence => true
end
