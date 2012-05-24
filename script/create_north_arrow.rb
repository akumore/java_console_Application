#!/usr/bin/env ruby
# This command will automatically be run when you run "rails" with Rails 3 gems installed from the root of your application.
require 'RMagick'

WIDTH        = 2 * 40
HEIGHT       = 2 * 40
STEP_SIZE    = 2 * 5
TEXT_HEIGHT  = 2 * 15
TOTAL_HEIGHT = HEIGHT + TEXT_HEIGHT
IMAGE_FILE = File.join(File.dirname(__FILE__), '..', 'app', 'assets', 'images', 'north-arrow-sprite.png')
RADIUS       = HEIGHT / 2 - 2

image = Magick::Image.new(WIDTH * 360 / STEP_SIZE, TOTAL_HEIGHT)

draw = Magick::Draw.new
draw.stroke('black')

center_y = TEXT_HEIGHT + HEIGHT / 2
offset_y = TEXT_HEIGHT
perimeter_y = offset_y + 2

draw.pointsize = 22
draw.font_family 'Arial'
draw.font_weight Magick::BoldWeight
draw.text_align Magick::CenterAlign
draw.font_style Magick::NormalStyle

(0...360).step(STEP_SIZE).each do |degree|
  offset_x = degree * WIDTH / STEP_SIZE
  center_x = offset_x + WIDTH / 2

  perimeter_x = degree * WIDTH / STEP_SIZE + WIDTH / 2

  line_x = Math.sin((degree * Math::PI / 180)) * RADIUS + center_x
  line_y = Math.sin((degree * Math::PI / 180) - Math::PI / 2) * RADIUS + center_y
  text_x = degree * WIDTH / STEP_SIZE + WIDTH / 2

  draw.stroke_width(1)
  draw.stroke_opacity(1)
  draw.fill_opacity(0)
  draw.circle(center_x, center_y, perimeter_x, perimeter_y)

  draw.stroke_width(3)
  draw.line(center_x, center_y, line_x, line_y)

  draw.stroke_width(1)
  draw.stroke_opacity(0)
  draw.fill_opacity(1)
  draw.text text_x, TEXT_HEIGHT - 2, 'N'
end

draw.draw(image)
image.resize_to_fit!(WIDTH * 360 / STEP_SIZE / 2, TOTAL_HEIGHT / 2)
image.write(IMAGE_FILE)

