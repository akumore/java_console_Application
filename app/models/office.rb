class Office
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :real_estates

  field :name, :type => String

  validates :name, :presence => true
end
