class Brick::Text < Brick::Base
  field :text, :type => String
  field :more_text, :type => String

  validates :text, :presence => true
end
