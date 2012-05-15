class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :parent, :class_name => 'Category'
  has_many :real_estates
  has_many :categories, :foreign_key => :parent_id

  scope :top_level, where(:parent_id => nil)

  field :name, :type => String
  field :label, :type => String, :localize => true

  validates :name, :uniqueness => true

  def apartment?
    name == 'apartment'
  end

  def house?
    name == 'house'
  end

  def property?
    name == 'properties'
  end

  def row_house?
    name == 'row_house'
  end
end