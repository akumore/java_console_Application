require 'export/export'

namespace :export do

  desc 'Run all exports (so far: homegate)'
  task :build => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export rake task"

    Export::Idx301::Target.all.each do |target|
      export = Export::Idx301::Exporter.new(target)
      RealEstate.published.each do |real_estate|
        export.add(real_estate)
      end
      export.finish
    end

    logger.info "Finished real estate export rake task."
  end

  desc 'Run all export cleanups (so far: homegate)'
  task :cleanup => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export cleanup rake task"

    Export::Idx301::Cleanup.new("#{Rails.root}/tmp/export").run
    logger.info "Finished real estate export cleanup rake task."
  end

  desc 'Run all export tasks'
  task :all => [:build, :cleanup]
end

desc 'Runs the export and export cleanup tasks'
task :export => 'export:all'
