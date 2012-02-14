class Brick::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w(title)

  embedded_in :page

  field :position, :type => Integer
end
