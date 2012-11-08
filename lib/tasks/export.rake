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
        export.add(real_estate)
      end
      export.finish
    end

    logger.info "Finished real estate export rake task."
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
  task :all => [:build, :cleanup]
end

desc 'Runs the export and export cleanup tasks'
task :export => 'export:all'
