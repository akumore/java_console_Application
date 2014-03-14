require 'assets/generate_north_arrow_images'

desc 'Generates nort arrow images'
task :generate_north_arrow_images do
  dir = File.join(File.dirname(__FILE__), 'app', 'assets', 'images', 'north-arrow')
  Assets::GenerateNorthArrowImages.generate_images(dir)
end
