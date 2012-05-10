namespace :db do

  desc <<-DESC
    Backups the database for the current Rails.env
  DESC
  task :backup do
    puts "TBD BACKUP TASK"
    #every :day, :at=>'11:30 pm' do
    #  rake 'db:backup',:output => File.join(path, "log/#{environment}_backup_cron.log")
    #end
  end

end