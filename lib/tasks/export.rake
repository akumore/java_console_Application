require 'export/export'

desc 'Run all exports (so far: homegate)'
task :export => :environment do
  dispatcher = Export::Dispatcher.new

  # register the homegate export with the dispatcher
  Export::Homegate::Exporter.new(dispatcher)

  # .. register any other custom exporter here

  # ^_^
  dispatcher.run
end
