#!/usr/bin/env ruby
# This command will automatically be run when you run "rails" with Rails 3 gems installed from the root of your application.
require 'RMagick'

WIDTH        = 40
HEIGHT       = 40
STEP_SIZE    = 5
TEXT_HEIGHT  = 10
TOTAL_HEIGHT = HEIGHT + TEXT_HEIGHT
RADIUS       = 18
IMAGE_FILE = File.join(File.dirname(__FILE__), '..', 'app', 'assets', 'images', 'north-arrow-sprite.png')

canvas = Magick::Image.new(WIDTH * 360 / STEP_SIZE, TOTAL_HEIGHT)
              #Magick::HatchFill.new('white','lightcyan2'))
canvas.transparent_color = 'white'

gc = Magick::Draw.new
gc.stroke('black')
gc.stroke_width(1)
gc.fill_opacity(0)
gc.stroke_antialias(true)

center_y = TEXT_HEIGHT + HEIGHT / 2
offset_y = TEXT_HEIGHT
perimeter_y = offset_y + 1

gc.pointsize = 9
gc.font_family 'arial'
gc.font_weight 100
gc.text_align Magick::CenterAlign
gc.font_style Magick::NormalStyle

(0...360).step(STEP_SIZE).each do |degree|
  offset_x = degree * WIDTH / STEP_SIZE
  center_x = offset_x + WIDTH / 2

  perimeter_x = degree * WIDTH / STEP_SIZE + WIDTH / 2

  line_x = Math.sin((degree * Math::PI / 180)) * RADIUS + center_x
  line_y = Math.sin((degree * Math::PI / 180) - Math::PI / 2) * RADIUS + center_y
  text_x = degree * WIDTH / STEP_SIZE + WIDTH / 2

  gc.stroke_width(1)
  gc.circle(center_x, center_y, perimeter_x, perimeter_y)
  gc.text text_x, TEXT_HEIGHT - 2, 'N'

  gc.stroke_width(2)
  gc.line(center_x, center_y, line_x, line_y)
end

gc.draw(canvas)
canvas.transparent('white').write(IMAGE_FILE)

