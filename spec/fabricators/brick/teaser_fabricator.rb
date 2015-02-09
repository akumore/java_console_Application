Fabricator(:teaser_brick, :from => :base_brick, :class_name => 'Brick::Teaser') do
  teaser_1 { Fabricate(:teaser) }
  teaser_2 { Fabricate(:teaser) }
end
