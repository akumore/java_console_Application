class Office
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :real_estates

  field :label, :type => String
  field :name, :type => String

  validates :label, :presence => true
  validates :name, :presence => true
end
