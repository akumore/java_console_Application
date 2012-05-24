#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

AlfredMueller::Application.load_tasks

task :generate_north_arrow_sprite do
  require 'assets/generate_north_arrow_sprite'
  file = File.join(File.dirname(__FILE__), 'app', 'assets', 'images', 'north-arrow-sprite.png')
  Assets::GenerateNorthArrowSprite.generate_image(file)
end
