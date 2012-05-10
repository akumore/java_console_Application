require 'export/export'

desc 'Run all exports (so far: homegate)'
task :export => :environment do
  logger = Logger.new(STDOUT)
  logger.formatter = Logger::Formatter.new
  logger.info "Starting real estate Export..."

  dispatcher = Export::Dispatcher.new

  # register the homegate export with the dispatcher
  Export::Homegate::Exporter.new(dispatcher)

  # .. register any other custom exporter here

  # ^_^
  dispatcher.run
  logger.info "Finished real estate Export."
end
