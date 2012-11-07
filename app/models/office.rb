class Office
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :real_estates

  field :label, :type => String

  validates :label, :presence => true
end
