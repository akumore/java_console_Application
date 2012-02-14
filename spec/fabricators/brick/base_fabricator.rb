Fabricator(:base_brick, :class_name => 'Brick::Base') do
  position { Fabricate.sequence }
end
