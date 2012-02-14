class Brick::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(title text accordion)

  embedded_in :page

  field :position, :type => Integer

  def type
    _type.underscore.split('/').last
  end
end
