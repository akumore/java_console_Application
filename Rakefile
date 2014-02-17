#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

AlfredMueller::Application.load_tasks

task :generate_north_arrow_images do
  require 'assets/generate_north_arrow_images'
  dir = File.join(File.dirname(__FILE__), 'app', 'assets', 'images', 'north-arrow')
  Assets::GenerateNorthArrowImages.generate_images(dir)
end

require 'special_sauce/tasks/rails'
