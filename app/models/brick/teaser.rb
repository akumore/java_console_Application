class Brick::Teaser < Brick::Base
  belongs_to :teaser_1, class_name: 'Teaser'
  belongs_to :teaser_2, class_name: 'Teaser'
  #field :teaser_1_id, :type => String
  #field :teaser_2_id, :type => String
end
