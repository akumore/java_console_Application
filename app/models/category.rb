class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :parent, :class_name => 'Category'
  has_many :real_estates
  has_many :categories, :foreign_key => :parent_id

  scope :top_level, where(:parent_id => nil)

  field :name, :type => String
  field :label, :type => String

  validates :name, :uniqueness => true
end