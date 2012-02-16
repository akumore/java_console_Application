class Brick::Title < Brick::Base
  field :title, :type => String

  validates :title, :presence => true

  def is_primary?
    first_brick = _parent.bricks.where(:_type => self.class.to_s).first
    first_brick == self
  end
end
