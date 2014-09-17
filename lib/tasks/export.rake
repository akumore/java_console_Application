require 'export/export'

namespace :export do

  desc 'Run all exports (homegate, immoscout, home.ch, immostreet)'
  task :build => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export rake task"

    Account.all.each do |account|
      export = Export::Idx301::Exporter.new(account)
      account.real_estates.published.each do |real_estate|
        logger.info(real_estate.id)
        export.add(real_estate)
      end
    end

    logger.info "Finished real estate export rake task."
  end

  desc 'Upload all exports (build must already be done)'
  task :upload => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate upload rake task"

    raise "do not run upload from development!" if Rails.env.development?

    Account.all.each do |account|
      export = Export::Idx301::Exporter.new(account)
      export.upload
    end

    logger.info "Finished real estate upload rake task."
  end

  desc 'Run all export cleanups (homegate, immoscout, home.ch, immostreet)'
  task :cleanup => :environment do
    logger = Logger.new(STDOUT)
    logger.formatter = Logger::Formatter.new
    logger.info "Starting real estate export cleanup rake task"

    Export::Idx301::Cleanup.new("#{Rails.root}/tmp/export").run
    logger.info "Finished real estate export cleanup rake task."
  end

  desc 'Run all export tasks'
  task :all => [:build, :upload, :cleanup]
end

desc 'Runs the export and export cleanup tasks'
task :export => 'export:all'
