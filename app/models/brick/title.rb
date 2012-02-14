class Brick::Title < Brick::Base
  field :title, :type => String

  validates :title, :presence => true
end
