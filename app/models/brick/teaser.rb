class Brick::Teaser < Brick::Base
  belongs_to :teaser_1, class_name: 'Teaser'
  belongs_to :teaser_2, class_name: 'Teaser'
  belongs_to :teaser_3, class_name: 'Teaser'
  belongs_to :teaser_4, class_name: 'Teaser'
end
