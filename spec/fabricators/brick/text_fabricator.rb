Fabricator(:text_brick, :from => :base_brick, :class_name => 'Brick::Text') do
  text 'Ein Text Brick'
  more_text 'Der More Text des Text Bricks'
end