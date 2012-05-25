require 'RMagick'

WIDTH        = 2 * 40
HEIGHT       = 2 * 40
STEP_SIZE    = 5
TEXT_HEIGHT  = 2 * 15
TOTAL_HEIGHT = HEIGHT + TEXT_HEIGHT
RADIUS       = HEIGHT / 2 - 2

module Assets
  class GenerateNorthArrowImages

    def self.generate_images(dirname)
      Dir.mkdir(dirname) unless File.exists?(dirname)
      (0...360).step(STEP_SIZE).each do |degree|
        image = Magick::Image.new(WIDTH, TOTAL_HEIGHT)

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

        offset_x = 0
        center_x = offset_x + WIDTH / 2

        perimeter_x = WIDTH / 2

        line_x = Math.sin((degree * Math::PI / 180)) * RADIUS + center_x
        line_y = Math.sin((degree * Math::PI / 180) - Math::PI / 2) * RADIUS + center_y
        text_x = WIDTH / 2

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
        draw.draw(image)
        image.resize_to_fit!(WIDTH / 2, TOTAL_HEIGHT / 2)
        image.write(File.join(dirname, "#{degree}.png"))
      end
    end

  end
end
