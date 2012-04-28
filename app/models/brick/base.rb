class Brick::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(title text accordion placeholder download)

  embedded_in :page
  default_scope asc(:position)

  field :position, :type => Integer

  def type
    _type.underscore.split('/').last
  end

  def prev
    idx = _parent.bricks.map(&:id).index(id)
    if idx - 1 >= 0
      _parent.bricks.to_a[idx - 1]
    else
      nil
    end
  end

  def next
    idx = _parent.bricks.map(&:id).index(id)
    _parent.bricks.to_a[idx + 1] rescue nil
  end
end
