namespace :db do

  desc <<-DESC
    Backups the database for the current Rails.env
  DESC
  task :backup do
    config = Mongoid.load! Rails.root.join('config/mongoid.yml')
    host_option = "-h #{[config['host'], config['port']].join(':')}"
    database_option = "-d #{config['database']}"
    user_option = "-u #{config['username']}" if config['username']
    password_option = "-p #{config['password']}" if config['password']

    dir_name = "#{Rails.env}-db-#{Time.now.strftime("%Y%m%d")}-#{Time.now.to_i}"
    dir_option = "-o #{Rails.root.join('db', 'backups', dir_name)}"

    mongodump [host_option, database_option, user_option, password_option, dir_option].join(" ")

    #every :day, :at=>'11:30 pm' do
    #  rake 'db:backup',:output => File.join(path, "log/#{environment}_backup_cron.log")
    #end
  end

end