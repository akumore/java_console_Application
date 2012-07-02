require 'export/export'

namespace :export do

  desc 'Run all exports (so far: homegate)'
  task :build => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export rake task"

    dispatcher = Export::Dispatcher.new("Export Dispatcher")

    # register the homegate export with the dispatcher
    Export::Homegate::Exporter.new(dispatcher)

    # .. register any other custom exporter here

    # ^_^
    dispatcher.start
    logger.info "Finished real estate export rake task."
  end

  desc 'Run all export cleanups (so far: homegate)'
  task :cleanup => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export cleanup rake task"

    Export::Homegate::Cleanup.new("#{Rails.root}/tmp/export").run
    logger.info "Finished real estate export cleanup rake task."
  end

  desc 'Run all export tasks'
  task :all => [:build, :cleanup]
end

desc 'Runs the export and export cleanup tasks'
task :export => 'export:all'
