class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :parent, :class_name => 'Category'
  has_many :real_estates
  has_many :categories, :foreign_key => :parent_id

  scope :top_level, where(:parent_id => nil)
  scope :sorted_by_utilization, order_by(utilization_sort_order: :asc)

  default_scope order_by([{:sort_order => :asc}, {:label => :asc}])

  field :name, :type => String
  field :label, :type => String, :localize => true
  field :sort_order, :type => Integer
  field :utilization, :type => String # used for internal grouping of categories by utilization
  field :utilization_sort_order, :type => Integer # used for sorting the group items

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

  def select_label
    label_translations['de'].presence || name
  end
end
