class Brick::Accordion < Brick::Base
  field :title, :type => String
  field :text, :type => String

  validates :title, :presence => true
  validates :text, :presence => true
end
